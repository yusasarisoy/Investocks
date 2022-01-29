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

  /// Holds the stock name.
  lazy var labelStock: UILabel = {
    let label = UILabel()
    return label
  }()

  // MARK: - Lifecycle

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?) {
      super.init(
        style: style,
        reuseIdentifier: reuseIdentifier)

      contentView.addSubview(labelStock)
    }

  override func layoutSubviews() {
    super.layoutSubviews()

    setupConstraints()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    labelStock.text = nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helpers

  /// Allows to setup constraints of **UIView** elements using SnapKit.
  private func setupConstraints() {
    labelStock.snp.makeConstraints { make in
      make.left.equalTo(contentView.safeAreaLayoutGuide).inset(10)
    }
  }
}
