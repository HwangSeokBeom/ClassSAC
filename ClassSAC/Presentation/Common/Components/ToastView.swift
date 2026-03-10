//
//  ToastView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import UIKit
import SnapKit

final class ToastView: BaseRootView {

    private let message: String

    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.textPrimary.withAlphaComponent(0.95)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.bgSurface
        label.font = AppFont.button.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    init(message: String) {
        self.message = message
        super.init(frame: .zero)
        messageLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureHierarchy() {
        [
            backgroundContainerView
        ].forEach { addSubview($0) }

        [
            messageLabel
        ].forEach { backgroundContainerView.addSubview($0) }
    }

    override func configureLayout() {
        backgroundContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    override func configureView() {
        backgroundColor = .clear
        alpha = 0
    }
}
