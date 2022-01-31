//
//  NetworkManager.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

class NetworkManager {

  /// Provides to create singleton of the **NetworkManager**.
  static let shared = NetworkManager()

  /// Completes getting stock information.
  typealias StocksCompletion = (Result<Stocks, Error>) -> Void

  /// Keeps the name of the stocks to be fetched.
  private var query = ""

  /// Checks whether fetching data of stocks is ready.
  private var reloadWhenReady: ((Result<Stocks, Error>) -> Void)?

  /// Provides to get name of stocks.
  func getStocksName() {
    let stringURL = "\(Constants.baseURL)/ForeksMobileInterviewSettings"
    guard let url = URL(string: stringURL) else {
      return
    }

    NetworkService().request(fromURL: url) { [weak self] (result: Result<Data, Error>) in
      switch result {
      case .success(let data):
        do {
          let myPageDefaults = try JSONDecoder().decode(MyPages.self, from: data).mypageDefaults
          self?.query = myPageDefaults?.compactMap { $0.cod }.joined(separator: "~") ?? ""

          if let completion = self?.reloadWhenReady {
            self?.getStocksInformation(completion: completion)
          }
        } catch let error {
          debugPrint("An error occurred while decoding stocks name:", error)
        }
      case .failure(let error):
        debugPrint("An error occurred while getting stocks name:", error)
      }
    }
  }

  /// Provides information about the selected stocks.
  func getStocksInformation(completion: @escaping StocksCompletion) {
    let stringURL = "\(Constants.url)/ForeksMobileInterview?fields=pdd,las&stcs=\(query)"
    guard !query.isEmpty,
          let url = URL(string: stringURL) else {
            reloadWhenReady = completion
            return
          }

    NetworkService().request(fromURL: url) { [weak self] (result: Result<Data, Error>) in
      switch result {
      case .success(let data):
        do {
          let stocks = try JSONDecoder().decode(Stocks.self, from: data)
          completion(.success(stocks))

          DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getStocksName()
          }
        } catch let error {
          completion(.failure(error))
          debugPrint("An error occurred while decoding stocks information:", error)
        }
      case .failure(let error):
        debugPrint("An error occurred while getting stocks information:", error)
      }
    }
  }
}
