//
//  ViewController.swift
//  Investocks
//
//  Created by Yuşa on 29.01.2022.
//

import SnapKit
import UIKit

class ViewController: UIViewController {

  // MARK: - Properties

  /// Displays the text "Hello, world!" to welcome users.
  private lazy var labelHello: UILabel = {
    let label = UILabel()
    label.text = "Hello, world!"
    view.addSubview(label)

    return label
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupConstraints()
  }

  // MARK: - Helpers

  /// Allows to setup constraints of **UIView** elements using SnapKit.
  private func setupConstraints() {
    labelHello.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
  }
}
