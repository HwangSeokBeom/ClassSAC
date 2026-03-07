//
//  UIViewController+Keyboard.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit

extension UIViewController {

    func enableKeyboardDismissGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleKeyboardDismiss)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleKeyboardDismiss() {
        view.endEditing(true)
    }
}
