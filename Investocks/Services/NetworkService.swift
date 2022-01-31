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
      let completionOnMainThread: (Result<T, Error>) -> Void = { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }

      var request = URLRequest(url: url)
      request.httpMethod = httpMethod.method

      let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
          completionOnMainThread(.failure(error))
          return
        }

        guard let urlResponse = response as? HTTPURLResponse else {
          return completionOnMainThread(.failure(ManagerErrors.invalidResponse))
        }

        if !(200..<300).contains(urlResponse.statusCode) {
          return completionOnMainThread(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
        }

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
