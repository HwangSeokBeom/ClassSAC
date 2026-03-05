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
    }
    
}

extension SignupViewController {
    
    @objc
    private func signupButtonTapped() {
        print("회원가입 버튼 클릭")
    }
    
}
