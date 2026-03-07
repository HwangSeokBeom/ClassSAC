//
//  UIViewController+Alert.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit

extension UIViewController {

    func showAlert(
        title: String = "알림",
        message: String,
        confirmTitle: String = "확인",
        onConfirm: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            onConfirm?()
        }

        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    func showNetworkAlert(message: String) {
        showAlert(
            title: "안내",
            message: message
        )
    }
}
