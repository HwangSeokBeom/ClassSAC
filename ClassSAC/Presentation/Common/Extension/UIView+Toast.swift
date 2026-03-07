//
//  UIView+Toast.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/6/26.
//

import UIKit
import SnapKit

extension UIView {

    func showToast(_ message: String) {
        let label = PaddingLabel()
        label.text = message
        label.textColor = .white
        label.backgroundColor = UIColor(white: 0.12, alpha: 0.95)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.alpha = 0

        addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.greaterThanOrEqualToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }

        UIView.animate(withDuration: 0.2) { label.alpha = 1 }
        UIView.animate(withDuration: 0.2, delay: 1.3, options: []) { label.alpha = 0 } completion: { _ in
            label.removeFromSuperview()
        }
    }
}

final class PaddingLabel: UILabel {
    private let insets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
}
