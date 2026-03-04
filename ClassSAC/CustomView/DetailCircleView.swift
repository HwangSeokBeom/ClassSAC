import UIKit
import SnapKit

final class DetailCircleView: UIView {

    // MARK: - UI Components
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Init
    init(icon: AppIcon, title: String) {
        super.init(frame: .zero)
        configureHierarchy()
        configureUI(icon: icon, title: title)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Hierarchy
    private func configureHierarchy() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    // MARK: - Configure UI
    private func configureUI(icon: AppIcon, title: String) {
        backgroundColor = AppColor.bgMuted
        layer.cornerRadius = 45

        // Icon
        iconImageView.image = icon.image
        iconImageView.tintColor = AppColor.accentPrimary
        iconImageView.contentMode = .scaleAspectFit

        // Title
        titleLabel.text = title
        titleLabel.font = AppFont.chip.font
        titleLabel.textColor = AppColor.textPrimary
        titleLabel.textAlignment = .center
    }

    // MARK: - Configure Layout
    private func configureLayout() {
        snp.makeConstraints {
            $0.size.equalTo(90)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(22)
        }
    }
}
