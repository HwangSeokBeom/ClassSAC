//
//  SignupViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit

final class SignupViewController: UIViewController {

    private let signupRootView = SignupRootView()

    override func loadView() {
        view = signupRootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        signupRootView.signupButton.addTarget(
            self,
            action: #selector(signupButtonTapped),
            for: .touchUpInside
        )

        applyTitleStyle()

       
        registerForTraitChanges([UITraitHorizontalSizeClass.self]) { [weak self] (view: SignupViewController, _) in
            self?.applyTitleStyle()
        }
    
    }

    private func applyTitleStyle() {
        let isRegular = (traitCollection.horizontalSizeClass == .regular)

        if isRegular {
            navigationItem.title = nil
            signupRootView.setInlineTitleHidden(false)
        } else {
            navigationItem.title = "회원가입"
            signupRootView.setInlineTitleHidden(true)
        }

        view.setNeedsLayout()
    }

    @objc private func signupButtonTapped() {
        print("회원가입 버튼 클릭")
    }
}
