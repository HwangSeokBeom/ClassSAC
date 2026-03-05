import UIKit
import SnapKit

final class DetailCircleView: BaseRootView {

    // MARK: - Properties
    private let icon: AppIcon
    private let title: String

    // MARK: - UI
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Init
    init(icon: AppIcon, title: String) {
        self.icon = icon
        self.title = title
        super.init(frame: .zero)
    }

    // MARK: - Configure
    override func configureHierarchy() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    override func configureLayout() {
        // 고정 사이즈 (필요 없으면 삭제 가능)
        snp.makeConstraints { $0.size.equalTo(90) }

        stackView.snp.makeConstraints { $0.center.equalToSuperview() }

        iconImageView.snp.makeConstraints { $0.size.equalTo(22) }
    }

    override func configureView() {
        backgroundColor = AppColor.bgMuted
        layer.cornerRadius = 45
        clipsToBounds = true

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6

        iconImageView.image = icon.image
        iconImageView.tintColor = AppColor.accentPrimary
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.font = AppFont.chip.font
        titleLabel.textColor = AppColor.textPrimary
        titleLabel.textAlignment = .center
    }
}
