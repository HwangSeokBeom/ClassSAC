import UIKit
import SnapKit

final class TagView: BaseRootView {

    // MARK: - Properties
    private let title: String
    private let icon: AppIcon

    // MARK: - UI
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Init
    init(title: String, icon: AppIcon = .bookmark) {
        self.title = title
        self.icon = icon
        super.init(frame: .zero)
    }

    // MARK: - Configure
    override func configureHierarchy() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    override func configureLayout() {
        iconImageView.snp.makeConstraints { $0.size.equalTo(14) }

        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }

    override func configureView() {
        backgroundColor = AppColor.tagOrangeBg
        layer.cornerRadius = 8
        clipsToBounds = true

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6

        iconImageView.image = icon.image
        iconImageView.tintColor = AppColor.tagOrange
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.font = AppFont.label.font
        titleLabel.textColor = AppColor.tagOrange
    }
}
