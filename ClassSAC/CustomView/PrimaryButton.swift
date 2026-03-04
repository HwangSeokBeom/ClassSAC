import UIKit
import SnapKit

final class PrimaryButton: UIButton {

    // MARK: - Button Style
    enum Style {
        case filled    // accent background, white text
        case disabled  // disabled state

        var backgroundColor: UIColor {
            switch self {
            case .filled:   return AppColor.accentPrimary
            case .disabled: return AppColor.textTertiary
            }
        }

        var foregroundColor: UIColor {
            switch self {
            case .filled:   return .white
            case .disabled: return .white
            }
        }

        var isEnabled: Bool {
            switch self {
            case .filled:   return true
            case .disabled: return false
            }
        }
    }

    // MARK: - Init
    init(title: String, icon: AppIcon? = nil, style: Style = .filled) {
        super.init(frame: .zero)
        configureButton(title: title, icon: icon, style: style)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    private func configureButton(title: String, icon: AppIcon?, style: Style) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = style.backgroundColor
        config.baseForegroundColor = style.foregroundColor
        config.cornerStyle = .fixed
        config.background.cornerRadius = 12

        // Title
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
            ])
        )

        // Icon
        if let icon = icon {
            config.image = icon.image
            config.imagePlacement = .leading
            config.imagePadding = 8
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
                pointSize: 13, weight: .semibold
            )
        }

        configuration = config
        isEnabled = style.isEnabled
    }

    private func configureLayout() {
        snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
}
