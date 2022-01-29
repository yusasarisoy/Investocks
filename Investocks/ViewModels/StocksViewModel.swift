//
//  StocksViewModel.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

class StocksViewModel {

  /// Holds the stocks.
  var stocks = [Stock]()

  /// Provides to reload and show stocks.
  var reloadStocks: ((Stocks) -> Void)?

  /// Notifies when stocks populated.
  var reloadTableViewClosure: (() -> Void)?

  init() {
    NetworkManager.shared.getStocksName()
  }

  /// Allows to start taking stocks.
  func initFetch() {
    NetworkManager.shared.getStocksInformation { [weak self] result in
      switch result {
      case .success(let stocks):
        self?.stocks.removeAll()
        self?.stocks = stocks.l
        self?.reloadStocks?(stocks)
        self?.reloadTableViewClosure?()
      case .failure(let error):
        debugPrint("An error occurred while getting stocks: \(error)")
      }
    }
  }
}
