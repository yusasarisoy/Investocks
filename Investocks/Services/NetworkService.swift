//
//  NetworkService.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

class NetworkService {

  /// These are the errors this class might return.
  enum ManagerErrors: Error {
    case invalidResponse
    case invalidStatusCode(Int)
  }

  /// The request method you like to use.
  enum HTTPMethod: String {
    case get
    case post

    var method: String { rawValue.uppercased() }
  }

  /// Request data from an endpoint.
  /// - Parameters:
  ///   - url: The **URL**.
  ///   - httpMethod: The HTTP Method to use, either get or post in this case.
  ///   - completion: The completion closure, returning a Result of either the generic type or an error.
  func request<T: Decodable>(
    fromURL url: URL,
    httpMethod: HTTPMethod = .get,
    completion: @escaping (Result<T, Error>)
    -> Void) {
      // Because URLSession returns on the queue it creates for the request,
      // we need to make sure we return on one and the same queue.
      // You can do this by either create a queue in your class (NetworkService)
      // which you return on, or return on the main queue.
      let completionOnMainThread: (Result<T, Error>) -> Void = { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }

      // Create the request. On the request you can define if it is a GET or POST request, add body and more.
      var request = URLRequest(url: url)
      request.httpMethod = httpMethod.method

      let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
        // First check if we got an error, if so we are not interested in the response or data.
        // Remember, and 404, 500, 501 http error code does not result in an error in URLSession, it
        // will only return an error here in case of e.g. Network timeout.
        if let error = error {
          completionOnMainThread(.failure(error))
          return
        }

        // Lets check the status code, we are only interested in results between 200 and 300 in statuscode.
        // If the statuscode is anything else we want to return the error with the statuscode that was returned.
        // In this case, we do not care about the data.
        guard let urlResponse = response as? HTTPURLResponse else {
          return completionOnMainThread(.failure(ManagerErrors.invalidResponse))
        }
        if !(200..<300).contains(urlResponse.statusCode) {
          return completionOnMainThread(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
        }

        // Now that all our prerequisites are fullfilled, we can take our data
        // and try to translate it to our generic type of T.
        guard let data = data else { return }
        if let data = data as? T {
          completionOnMainThread(.success(data))
          return
        }
        do {
          let users = try JSONDecoder().decode(T.self, from: data)
          completionOnMainThread(.success(users))
        } catch {
          debugPrint("Could not convert the data. Reason: \(error.localizedDescription)")
          completionOnMainThread(.failure(error))
        }
      }

      urlSession.resume()
    }
}
