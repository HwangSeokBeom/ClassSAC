import UIKit
import SnapKit

final class SectionHeaderView: BaseRootView {

    // MARK: - Properties
    private let title: String

    // MARK: - UI
    private let lineView = UIView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Init
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }

    // MARK: - Configure
    override func configureHierarchy() {
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        lineView.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(1)
        }
    }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12

        lineView.backgroundColor = AppColor.textPrimary

        titleLabel.text = title
        titleLabel.font = AppFont.caption.font
        titleLabel.textColor = AppColor.textPrimary
    }
}
