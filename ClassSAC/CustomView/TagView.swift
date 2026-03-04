import UIKit
import SnapKit

final class TagView: UIView {

    // MARK: - UI Components
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Init
    init(title: String, icon: AppIcon = .bookmark) {
        super.init(frame: .zero)
        configureHierarchy()
        configureUI(title: title, icon: icon)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Hierarchy
    private func configureHierarchy() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    // MARK: - Configure UI
    private func configureUI(title: String, icon: AppIcon) {
        backgroundColor = AppColor.tagOrangeBg
        layer.cornerRadius = 8

        iconImageView.image = icon.image
        iconImageView.tintColor = AppColor.tagOrange
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.font = AppFont.label.font
        titleLabel.textColor = AppColor.tagOrange

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
    }

    // MARK: - Configure Layout
    private func configureLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(14)
        }

        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}
