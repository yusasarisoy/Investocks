//
//  String+Extensions.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import Foundation

extension String {

  /// Provides to remove a **Double** to a **String**.
  /// - Returns: A **Double** converted from **String**.
  func toDouble() -> Double {
    let string = self.replacingOccurrences(of: ",", with: ".")
    return Double(string) ?? 0
  }

  /// Provides to remove first character from the string.
  /// - Returns: A **String** without its first character.
  func removeFirstChar() -> String {
    String(self.dropFirst())
  }
}
