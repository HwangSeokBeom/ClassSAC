import UIKit
import SnapKit

final class SortButton: UIButton {

    // MARK: - Init
    init(title: String = "최신순") {
        super.init(frame: .zero)
        configureButton(title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    private func configureButton(title: String) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = AppColor.bgSurface
        config.baseForegroundColor = AppColor.textSecondary
        config.cornerStyle = .capsule
        config.background.cornerRadius = 10
        config.background.strokeColor = AppColor.borderSubtle
        config.background.strokeWidth = 1

        // Title
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 11, weight: .medium)
            ])
        )

        // Sort Icon (leading)
        config.image = AppIcon.sort.image
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: 11, weight: .medium
        )

        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)

        configuration = config
    }
}
