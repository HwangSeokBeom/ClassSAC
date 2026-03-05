import UIKit
import SnapKit

final class InputField: UIView {

    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let textField = UITextField()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.textTertiary
        button.setImage(AppIcon.eyeSlash.image, for: .normal)
        button.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(title: String, placeholder: String, icon: AppIcon, isSecure: Bool = false) {
        super.init(frame: .zero)
        configureHierarchy()
        configureUI(title: title, placeholder: placeholder, icon: icon, isSecure: isSecure)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Hierarchy
    private func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textField)
        containerView.addSubview(toggleButton)
    }

    // MARK: - Configure UI
    private func configureUI(title: String, placeholder: String, icon: AppIcon, isSecure: Bool) {
        // Title Label
        titleLabel.text = title
        titleLabel.font = AppFont.label.font
        titleLabel.textColor = AppColor.textPrimary

        // Container
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = AppColor.borderSubtle.cgColor

        // Icon
        iconImageView.image = icon.image
        iconImageView.tintColor = AppColor.textTertiary
        iconImageView.contentMode = .scaleAspectFit

        // TextField
        textField.placeholder = placeholder
        textField.font = AppFont.button.font
        textField.textColor = AppColor.textPrimary
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: AppColor.textTertiary,
                .font: UIFont.systemFont(ofSize: 13)
            ]
        )

        // Toggle Button
        toggleButton.isHidden = !isSecure
    }

    // MARK: - Configure Layout
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(46)
        }

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }

        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(18)
            $0.height.equalTo(16)
        }

        textField.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc private func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
        let icon: AppIcon = textField.isSecureTextEntry ? .eyeSlash : .eye
        toggleButton.setImage(icon.image, for: .normal)
    }
}
