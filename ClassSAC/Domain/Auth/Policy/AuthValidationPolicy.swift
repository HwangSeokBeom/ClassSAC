//
//  AuthValidationPolicy.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

enum AuthValidationPolicy {

    static let minimumTextCount = 2
    static let maximumTextCount = 10

    static var lengthGuideMessage: String {
        "\(minimumTextCount)자 이상 \(maximumTextCount)자 미만으로 설정해주세요."
    }

    static let emailGuideMessage = "올바른 이메일 형식을 입력해주세요."

    static func isValidLength(_ text: String) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.count >= minimumTextCount &&
               trimmedText.count < maximumTextCount
    }

    static func isValidEmail(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        let emailRegex = /^(?!\.)[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

        return trimmedEmail.wholeMatch(of: emailRegex) != nil
    }
}
