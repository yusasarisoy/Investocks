//
//  ExchangeInfo.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

struct ExchangeInfo: Decodable {
  let stockInfo: [StockInfo]?
  let criteriaInfo: [CriteriaInfo]?
}

extension ExchangeInfo {
  enum CodingKeys: String, CodingKey {
    case stockInfo = "mypageDefaults"
    case criteriaInfo = "mypage"
  }
}
