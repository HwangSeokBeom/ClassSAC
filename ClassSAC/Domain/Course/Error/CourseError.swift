//
//  CourseError.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CourseError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case invalidSesacKey
    case tooManyRequests
    case serverError
    case network
    case unknown
}

extension CourseError {

    var userMessage: String {
        switch self {
        case .badRequest:
            return "요청 값을 확인해주세요."

        case .unauthorized:
            return "로그인이 만료되었습니다. 다시 로그인해주세요."

        case .forbidden:
            return "접근 권한이 없습니다."

        case .notFound:
            return "요청한 클래스를 찾을 수 없습니다."

        case .invalidSesacKey:
            return "인증 키가 올바르지 않습니다."

        case .tooManyRequests:
            return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."

        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."

        case .network:
            return "네트워크 연결이 원활하지 않습니다.\n인터넷 상태를 확인해주세요."

        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
