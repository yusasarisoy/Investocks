//
//  InvestocksTests.swift
//  InvestocksTests
//
//  Created by Yuşa on 29.01.2022.
//

import XCTest
@testable import Investocks

class InvestocksTests: XCTestCase {

  var urlSession: URLSession?
  let networkManager = NetworkManager.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    urlSession = URLSession(configuration: .default)
  }

  override func tearDownWithError() throws {
    urlSession = nil
    try super.tearDownWithError()
  }

  func testGetStocksName() throws {
    // given
    let stringURL = "\(Constants.baseURL)/ForeksMobileInterviewSettings"
    guard let url = URL(string: stringURL) else {
      return
    }

    let promise = expectation(description: "Status code: 200")

    // when
    let dataTask = urlSession?.dataTask(with: url) { _, response, error in
      // then
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    dataTask?.resume()

    wait(for: [promise], timeout: 5)
  }

  func testGetStocksInformation() throws {
    // given
    let stringURL = "\(Constants.baseURL)/ForeksMobileInterview?fields=pdd,las&stcs=XGLD~BRENT"
    guard let url = URL(string: stringURL) else {
      return
    }

    let promise = expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?

    // when
    let dataTask = urlSession?.dataTask(with: url) { _, response, error in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }

    dataTask?.resume()
    wait(for: [promise], timeout: 5)

    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
}
