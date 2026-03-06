//
//  IconTextFieldView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit
import SnapKit

final class IconTextFieldView: BaseRootView {

    enum RightAccessoryType {
        case none
        case toggleSecure
    }

    private let leftIconImage: UIImage?
    private let placeholderText: String
    private let keyboardType: UIKeyboardType
    private let initialSecureTextEntry: Bool
    private let rightAccessoryType: RightAccessoryType

    var text: String {
        inputTextField.text ?? ""
    }

    private let textFieldContainerView = UIView()
    private let leftAccessoryIconImageView = UIImageView()
    private let inputTextField = UITextField()
    private let rightAccessoryButton = UIButton(type: .system)

    init(
        leftIcon: UIImage?,
        placeholderText: String,
        keyboardType: UIKeyboardType,
        isSecureTextEntry: Bool,
        rightAccessoryType: RightAccessoryType
    ) {
        self.leftIconImage = leftIcon
        self.placeholderText = placeholderText
        self.keyboardType = keyboardType
        self.initialSecureTextEntry = isSecureTextEntry
        self.rightAccessoryType = rightAccessoryType
        super.init(frame: .zero)
    }

    override func configureHierarchy() {
        addSubview(textFieldContainerView)

        [
            leftAccessoryIconImageView,
            inputTextField,
            rightAccessoryButton
        ].forEach { textFieldContainerView.addSubview($0) }
    }

    override func configureLayout() {
        textFieldContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        leftAccessoryIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }

        rightAccessoryButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }

        inputTextField.snp.makeConstraints { make in
            make.leading.equalTo(leftAccessoryIconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()

            switch rightAccessoryType {
            case .none:
                make.trailing.equalToSuperview().inset(12)
            case .toggleSecure:
                make.trailing.equalTo(rightAccessoryButton.snp.leading).offset(-8)
            }
        }
    }

    override func configureView() {
        textFieldContainerView.backgroundColor = AppColor.bgSurface
        textFieldContainerView.layer.cornerRadius = 12
        textFieldContainerView.layer.borderWidth = 1
        textFieldContainerView.layer.borderColor = AppColor.borderSubtle.cgColor
        textFieldContainerView.clipsToBounds = true

        leftAccessoryIconImageView.image = leftIconImage
        leftAccessoryIconImageView.tintColor = AppColor.textTertiary
        leftAccessoryIconImageView.contentMode = .scaleAspectFit

        inputTextField.placeholder = placeholderText
        inputTextField.font = AppFont.body.font
        inputTextField.textColor = AppColor.textPrimary
        inputTextField.keyboardType = keyboardType
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputTextField.spellCheckingType = .no
        inputTextField.isSecureTextEntry = initialSecureTextEntry
        inputTextField.returnKeyType = .done
        inputTextField.clearButtonMode = .never

        rightAccessoryButton.tintColor = AppColor.textTertiary

        switch rightAccessoryType {
        case .none:
            rightAccessoryButton.isHidden = true

        case .toggleSecure:
            rightAccessoryButton.isHidden = false
            let iconImage = initialSecureTextEntry ? AppIcon.eyeSlash.image : AppIcon.eye.image
            rightAccessoryButton.setImage(iconImage, for: .normal)
            rightAccessoryButton.addTarget(self, action: #selector(didTapRightAccessoryButton), for: .touchUpInside)
        }
    }

    func setReturnKeyType(_ returnKeyType: UIReturnKeyType) {
        inputTextField.returnKeyType = returnKeyType
    }

    func setTextFieldDelegate(_ delegate: UITextFieldDelegate?) {
        inputTextField.delegate = delegate
    }

    func addTextFieldTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        inputTextField.addTarget(target, action: action, for: controlEvents)
    }

    func focus() {
        inputTextField.becomeFirstResponder()
    }

    func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }

    @objc
    private func didTapRightAccessoryButton() {
        let wasFirstResponder = inputTextField.isFirstResponder
        let currentSelectedTextRange = inputTextField.selectedTextRange
        let currentText = inputTextField.text

        inputTextField.isSecureTextEntry.toggle()

        let iconImage = inputTextField.isSecureTextEntry ? AppIcon.eyeSlash.image : AppIcon.eye.image
        rightAccessoryButton.setImage(iconImage, for: .normal)

        inputTextField.text = nil
        inputTextField.text = currentText

        if wasFirstResponder {
            inputTextField.becomeFirstResponder()

            if let currentSelectedTextRange {
                inputTextField.selectedTextRange = currentSelectedTextRange
            }
        }
    }
}
