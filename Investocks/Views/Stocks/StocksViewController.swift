//
//  StocksViewController.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import SnapKit
import UIKit

class StocksViewController: UIViewController {

  // MARK: - Properties

  /// Lists the stocks' information.
  private lazy var tableViewStocks: UITableView = {
    let tableView = UITableView()
    tableView.register(
      StocksCell.self,
      forCellReuseIdentifier: StocksCell.identifier)
    view.addSubview(tableView)

    return tableView
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    tableViewStocks.dataSource = self

    setupConstraints()
  }

  // MARK: - Helpers

  /// Allows to setup constraints of **UIView** elements using SnapKit.
  private func setupConstraints() {
    tableViewStocks.snp.makeConstraints { make in
      make.top.left.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(10)
    }
  }
}

extension StocksViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int)
  -> Int {
    1
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
  -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: StocksCell.identifier,
      for: indexPath) as? StocksCell else {
        fatalError()
      }

    cell.labelStock.text = "AAPL"
    return cell
  }
}
