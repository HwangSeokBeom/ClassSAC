//
//  LoginViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit

final class LoginViewController: UIViewController {

    private let loginRootView = LoginRootView()

    override func loadView() {
        view = loginRootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    private func bindActions() {
        loginRootView.onTapLoginButton = { [weak self] emailText, passwordText in
            guard let self else { return }

            let trimmedEmailText = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedPasswordText = passwordText.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedEmailText.isEmpty {
                self.view.showToast("이메일을 입력해주세요.")
                return
            }

            if trimmedPasswordText.isEmpty {
                self.view.showToast("비밀번호를 입력해주세요.")
                return
            }

            self.view.showToast("로그인 시도")
            // TODO: 로그인 로직 연결
        }

        loginRootView.onTapSignupButton = { [weak self] in
            guard let self else { return }
            let signupViewController = SignupViewController()
            navigationController?.pushViewController(signupViewController, animated: true)
        }
    }
}
