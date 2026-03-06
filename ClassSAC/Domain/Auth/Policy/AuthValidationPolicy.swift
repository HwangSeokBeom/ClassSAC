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

    static func isValidLength(_ text: String) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.count >= minimumTextCount && trimmedText.count < maximumTextCount
    }
}
