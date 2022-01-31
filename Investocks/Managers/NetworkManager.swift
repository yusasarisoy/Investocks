//
//  NetworkManager.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

protocol NetworkManagerProtocol {
  func getStocksName()
  func getStocksInformation(completion: @escaping (Result<Stocks, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {

  /// Provides to create singleton of the **NetworkManager**.
  static let shared = NetworkManager()

  /// Keeps the name of the stocks to be fetched.
  private var query = ""

  /// Checks whether fetching data of stocks is ready.
  private var reloadWhenReady: ((Result<Stocks, Error>) -> Void)?

  /// Provides to create an instance of the **CriteriaManager**.
  var criteriaManager: CriteriaManager

  init(criteriaManager: CriteriaManager = CriteriaManager.shared) {
    self.criteriaManager = criteriaManager
  }

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
          let exchangeInfo = try JSONDecoder().decode(ExchangeInfo.self, from: data)

          guard
            let stockInfos = exchangeInfo.stockInfo,
            let criteriaInfos = exchangeInfo.criteriaInfo else {
              return
            }

          self?.query = stockInfos.compactMap { $0.cod }.joined(separator: "~")

          if self?.criteriaManager.criteria.isEmpty ?? true {
            self?.criteriaManager.criteria = criteriaInfos
          }

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
  func getStocksInformation(completion: @escaping (Result<Stocks, Error>) -> Void) {
    var stringURL = "\(Constants.baseURL)/ForeksMobileInterview?fields="
    stringURL.append("\(criteriaManager.firstCriteria),\(criteriaManager.secondCriteria)&stcs=\(query)")
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
