//
//  UIView+Toast.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import UIKit
import SnapKit

extension UIView {

    func showToast(
        _ message: String,
        duration: TimeInterval = 1.3
    ) {
        removeExistingToastView()

        let toastView = ToastView(message: message)

        [
            toastView
        ].forEach { addSubview($0) }

        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.greaterThanOrEqualToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.88)
        }

        layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            toastView.alpha = 1
        }

        UIView.animate(withDuration: 0.2, delay: duration, options: []) {
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }

    private func removeExistingToastView() {
        subviews
            .compactMap { $0 as? ToastView }
            .forEach { $0.removeFromSuperview() }
    }
}
