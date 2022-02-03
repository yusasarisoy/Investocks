//
//  Stock.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

struct Stock: Decodable {
  let tke, ddi, low, hig, buy, sel, pdc, cei, flo, gco, clo, pdd, las: String?
}
