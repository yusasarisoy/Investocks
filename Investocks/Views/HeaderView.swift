//
//  HeaderView.swift
//  Investocks
//
//  Created by Yuşa on 30.01.2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

  // MARK: - Properties

  /// Presents the identifier of **UITableViewHeaderFooterView**.
  static let identifier = "headerView"

  /// Checks whether the first criteria is clicked.
  var isFirstClicked = false

  /// Represents stock names.
  lazy var labelStock: UILabel = {
    let label = UILabel()
    label.text = "Sembol"
    return label
  }()

  /// Represents first criteria button to change criteria.
  lazy var buttonFirstCriteria: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 12
    button.setTitle(
      "Son",
      for: .normal)
    button.addTarget(
      self,
      action: #selector(buttonCriteriaDidTap(_:)),
      for: .touchUpInside)
    return button
  }()

  /// Represents second criteria button to change criteria.
  lazy var buttonSecondCriteria: UIButton = {
    let button = UIButton()
    button.tag = 2
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 12
    button.setTitle(
      "%Fark",
      for: .normal)
    button.addTarget(
      self,
      action: #selector(buttonCriteriaDidTap(_:)),
      for: .touchUpInside)
    return button
  }()

  /// Provides to create singleton of the **CriteriaManager**.
  var criteriaManager: CriteriaManager = CriteriaManager.shared

  // MARK: - Lifecycle

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    contentView.addSubview(labelStock)
    contentView.addSubview(buttonFirstCriteria)
    contentView.addSubview(buttonSecondCriteria)

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  /// Allows to setup constraints of **UIView** elements using SnapKit.
  private func setupConstraints() {
    labelStock.snp.makeConstraints { make in
      make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
      make.left.equalTo(contentView.bounds.height).offset(40)
    }

    buttonSecondCriteria.snp.makeConstraints { make in
      make.width.equalTo(70)
      make.right.equalTo(contentView.safeAreaLayoutGuide)
      make.centerY.equalToSuperview()
    }

    buttonFirstCriteria.snp.makeConstraints { make in
      make.width.equalTo(70)
      make.right.equalTo(buttonSecondCriteria.snp.left).inset(-25)
      make.centerY.equalToSuperview()
    }
  }

  /// Provides to open **UIPickerView** to change criteria.
  /// - Parameter sender: The **UIButton** that clicked.
  @objc func buttonCriteriaDidTap(_ sender: UIButton) {
    isFirstClicked = sender.tag == 1

    let alert = UIAlertController(
      title: "Kriter Seçiniz",
      message: "\n\n\n\n\n\n",
      preferredStyle: .alert)

    let pickerFrame = UIPickerView(frame: CGRect(
      x: 5,
      y: 20,
      width: 250,
      height: 140))

    alert.view.addSubview(pickerFrame)

    pickerFrame.dataSource = self
    pickerFrame.delegate = self

    alert.addAction(UIAlertAction(
      title: "OK",
      style: .default,
      handler: nil))

    self.window?.rootViewController?.present(
      alert,
      animated: true,
      completion: nil)
  }
}

extension HeaderView: UIPickerViewDelegate {
  func pickerView(
    _ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int)
  -> String? {
    criteriaManager.criteria[row].name
  }

  func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int) {
      let selectedRow = criteriaManager.criteria[row]

      if isFirstClicked {
        criteriaManager.firstCriteria = selectedRow.key ?? ""
        buttonFirstCriteria.setTitle(
          selectedRow.name ?? "",
          for: .normal)
      } else {
        criteriaManager.secondCriteria = selectedRow.key ?? ""
        buttonSecondCriteria.setTitle(
          selectedRow.name ?? "",
          for: .normal)
      }
    }
}

extension HeaderView: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView)
  -> Int {
    1
  }

  func pickerView(
    _ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int)
  -> Int {
    criteriaManager.criteria.count
  }
}
