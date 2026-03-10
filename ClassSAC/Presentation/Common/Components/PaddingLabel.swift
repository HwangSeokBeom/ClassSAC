//
//  PaddingLabel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import UIKit

final class PaddingLabel: UILabel {

    var textInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetBounds = bounds.inset(by: textInsets)
        let textRectangle = super.textRect(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)

        return CGRect(
            x: textRectangle.origin.x - textInsets.left,
            y: textRectangle.origin.y - textInsets.top,
            width: textRectangle.width + textInsets.left + textInsets.right,
            height: textRectangle.height + textInsets.top + textInsets.bottom
        )
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = super.intrinsicContentSize

        return CGSize(
            width: labelSize.width + textInsets.left + textInsets.right,
            height: labelSize.height + textInsets.top + textInsets.bottom
        )
    }
}
