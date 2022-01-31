//
//  CriteriaManager.swift
//  Investocks
//
//  Created by Yuşa on 30.01.2022.
//

import Foundation

class CriteriaManager {

  /// Provides to create singleton of the **CriteriaManager**.
  static let shared = CriteriaManager()

  /// Holds the key of first criteria.
  var firstCriteria = "las"

  /// Holds the key of second criteria.
  var secondCriteria = "pdd"

  /// Holds all the criterias with key and name.
  var criteria = [CriteriaInfo]()

  /// Keeps the selected criteria.
  var selectedCriteria: [String] {
    return [firstCriteria, secondCriteria]
  }

  /// Provides to get criteria value based on the selected criteria.
  func showCriteriaValue(
    selectedCriteria: Criteria,
    stock: Stock)
  -> String {
    var criteriaValue: String?

    switch selectedCriteria {
    case .las:
      criteriaValue = stock.las
    case .pdd:
      criteriaValue = stock.pdd
    case .buy:
      criteriaValue = stock.buy
    case .cei:
      criteriaValue = stock.cei
    case .ddi:
      criteriaValue = stock.ddi
    case .flo:
      criteriaValue = stock.flo
    case .gco:
      criteriaValue = stock.gco
    case .hig:
      criteriaValue = stock.hig
    case .low:
      criteriaValue = stock.low
    case .pdc:
      criteriaValue = stock.pdc
    case .sel:
      criteriaValue = stock.sel
    }

    return criteriaValue ?? ""
  }
}
