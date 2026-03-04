import UIKit
import SnapKit

final class SectionHeaderView: UIView {

    // MARK: - UI Components
    private let lineView = UIView()
    private let titleLabel = UILabel()

    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        configureHierarchy()
        configureUI(title: title)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Hierarchy
    private func configureHierarchy() {
        let stackView = UIStackView(arrangedSubviews: [lineView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: - Configure UI
    private func configureUI(title: String) {
        lineView.backgroundColor = AppColor.textPrimary

        titleLabel.text = title
        titleLabel.font = AppFont.caption.font
        titleLabel.textColor = AppColor.textPrimary
    }

    // MARK: - Configure Layout
    private func configureLayout() {
        lineView.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(1)
        }
    }
}
