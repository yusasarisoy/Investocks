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

  /// Provides to create an instance of the **StocksViewModel**.
  private let viewModel = StocksViewModel()

  /// Lists the information of stocks.
  private lazy var tableViewStocks: UITableView = {
    let tableView = UITableView()
    tableView.register(
      StocksCell.self,
      forCellReuseIdentifier: StocksCell.identifier)
    tableView.register(
      HeaderView.self,
      forHeaderFooterViewReuseIdentifier: HeaderView.identifier)

    view.addSubview(tableView)

    return tableView
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    tableViewStocks.delegate = self
    tableViewStocks.dataSource = self

    setupConstraints()

    viewModel.initFetch()

    viewModel.reloadTableViewClosure = { () in
      DispatchQueue.main.async { [weak self] in
        self?.tableViewStocks.reloadData()
      }
    }
  }

  // MARK: - Methods

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
    viewModel.stocks.count
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

    cell.configure(with: viewModel.stocks[indexPath.row])

    return cell
  }

  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath)
  -> CGFloat {
    UITableView.automaticDimension
  }
}

extension StocksViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int)
  -> UIView? {
    guard let view = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: HeaderView.identifier) as? HeaderView else {
        return UIView()
      }
    return view
  }

  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int)
  -> CGFloat {
    return 50
  }
}
