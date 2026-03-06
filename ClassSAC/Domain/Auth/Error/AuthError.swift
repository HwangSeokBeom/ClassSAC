//
//  AuthError.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

enum AuthError: Error {
    case invalidCredential
    case duplicateEmail
    case unauthorized
    case network
    case unknown
}

extension AuthError {

    var userMessage: String {
        switch self {
        case .invalidCredential:
            return "이메일 또는 비밀번호가 올바르지 않습니다."
        case .duplicateEmail:
            return "이미 가입된 유저입니다."
        case .unauthorized:
            return "다시 로그인해주세요."
        case .network:
            return "네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
