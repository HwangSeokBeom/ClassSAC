//
//  ProfileError.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

enum ProfileError: Error {
    case unauthorized
    case forbidden
    case decoding
    case network
    case invalidRequest
    case unknown

    var userMessage: String {
        switch self {
        case .unauthorized:
            return "로그인이 만료되었습니다. 다시 로그인해주세요."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .decoding:
            return "프로필 정보를 불러오는 중 데이터 처리에 실패했습니다."
        case .network:
            return "네트워크 연결을 확인해주세요."
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
