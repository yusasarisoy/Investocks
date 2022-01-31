//
//  StocksCell.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import SnapKit
import UIKit

class StocksCell: UITableViewCell {

  // MARK: - Properties

  /// Presents the identifier of **UITableViewCell**.
  static let identifier = "stocksCell"

  /// Holds the stock's current status.
  lazy var imageViewStatusChange: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()

  /// Holds the name of stock.
  lazy var labelStock: UILabel = {
    let label = UILabel()
    return label
  }()

  /// Holds the last update time of stock.
  lazy var labelLastUpdateTime: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13)
    return label
  }()

  /// Holds the first criteria based on the selected criteria.
  lazy var labelFirstCriteria: UILabel = {
    let label = UILabel()
    return label
  }()

  /// Holds the second criteria based on the selected criteria.
  lazy var labelSecondCriteria: UILabel = {
    let label = UILabel()
    return label
  }()

  /// Provides to create singleton of the **UserDefaults**.
  let userDefaults = UserDefaults.standard

  /// Provides to create singleton of the **CriteriaManager**.
  var criteriaManager: CriteriaManager = CriteriaManager.shared

  // MARK: - Lifecycle

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?) {
      super.init(
        style: style,
        reuseIdentifier: reuseIdentifier)

      contentView.addSubview(imageViewStatusChange)
      contentView.addSubview(labelStock)
      contentView.addSubview(labelLastUpdateTime)
      contentView.addSubview(labelFirstCriteria)
      contentView.addSubview(labelSecondCriteria)
    }

  override func layoutSubviews() {
    super.layoutSubviews()

    setupConstraints()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageViewStatusChange.image = nil
    labelStock.text = nil
    labelLastUpdateTime.text = nil
    labelFirstCriteria.text = nil
    labelSecondCriteria.text = nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  /// Allows to setup constraints of **UIView** elements using SnapKit.
  private func setupConstraints() {
    imageViewStatusChange.snp.makeConstraints { make in
      make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
      make.width.height.equalTo(contentView.bounds.height - 25)
      make.centerY.equalToSuperview()
    }

    labelStock.snp.makeConstraints { make in
      make.left.equalTo(imageViewStatusChange.snp.right).offset(10)
    }

    labelLastUpdateTime.snp.makeConstraints { make in
      make.left.equalTo(imageViewStatusChange.snp.right).offset(10)
      make.top.equalTo(labelStock.snp.bottom).offset(5)
    }

    labelSecondCriteria.snp.makeConstraints { make in
      make.right.equalTo(contentView.safeAreaLayoutGuide).inset(10)
      make.centerY.equalToSuperview()
    }

    labelFirstCriteria.snp.makeConstraints { make in
      make.right.equalTo(labelSecondCriteria.snp.left).inset(-30)
      make.centerY.equalToSuperview()
    }
  }

  /// Determines whether to set the color of the values.
  /// - Parameter criteria: Holds the selected criteria.
  /// - Returns: A **Boolean** to determine if the values should be colored.
  func textColorIfNeeded(criteria: String) -> Bool {
    Criteria(rawValue: criteria) == .pdd || Criteria(rawValue: criteria) == .ddi
  }

  /// Provides to populate cell with its corresponding stock information.
  /// - Parameter stock: Holds the information about stock.
  func configure(with stock: Stock) {
    guard
      let stockName = stock.tke,
      let stockUpdatedTime = stock.clo,
      let stockPrice = stock.las
    else {
      return
    }

    let stockFirstValue = criteriaManager.showCriteriaValue(
      selectedCriteria: Criteria(rawValue: criteriaManager.firstCriteria) ?? .pdd,
      stock: stock)
    let stockSecondValue = criteriaManager.showCriteriaValue(
      selectedCriteria: Criteria(rawValue: criteriaManager.secondCriteria) ?? .pdd,
      stock: stock)

    let previousPrice = userDefaults.double(forKey: stockName)
    let showPercentage = stock.ddi != nil || stock.pdd != nil
    let isNegative = (stockPrice.toDouble() - previousPrice) < 0
    let textColor: UIColor = isNegative ? .red : .green

    userDefaults.set(stockPrice.toDouble(), forKey: stockName)

    let changePercentage = showPercentage ? stockSecondValue.removeFirstChar() : stockSecondValue
    let changeImage = isNegative ? Constants.downArrow : Constants.upArrow

    imageViewStatusChange.image = UIImage(named: changeImage)
    labelStock.text = stockName
    labelLastUpdateTime.text = stockUpdatedTime
    labelFirstCriteria.text = stockFirstValue
    labelSecondCriteria.text = showPercentage ? "%\(changePercentage)" : changePercentage

    labelFirstCriteria.textColor = textColorIfNeeded(criteria: criteriaManager.firstCriteria)
    ? textColor
    : UIColor.label
    labelSecondCriteria.textColor = textColorIfNeeded(criteria: criteriaManager.secondCriteria)
    ? textColor
    : UIColor.label
  }
}
