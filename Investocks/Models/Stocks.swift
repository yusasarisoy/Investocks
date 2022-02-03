//
//  Stocks.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

struct Stocks: Decodable {
  let list: [Stock]
  let value: String?
}

extension Stocks {
  enum CodingKeys: String, CodingKey {
    case list = "l"
    case value = "z"
  }
}
