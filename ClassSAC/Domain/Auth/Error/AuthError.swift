//
//  AuthError.swift
//  ClassSAC
//

import Foundation

enum AuthError: Error {
    
    case invalidCredential       
    case duplicateEmail
    case unauthorized
    case badRequest
    case resourceNotFound
    case invalidSesacKey
    case tooManyRequests
    case serverError
    
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
            return "접근 권한이 없습니다. 다시 로그인해주세요."
            
        case .badRequest:
            return "필수 입력값을 확인해주세요."
            
        case .resourceNotFound:
            return "요청한 정보를 찾을 수 없습니다."
            
        case .invalidSesacKey:
            return "인증 키가 올바르지 않습니다."
            
        case .tooManyRequests:
            return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."
            
        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
            
        case .network:
            return "네트워크 연결이 일시적으로 원활하지 않습니다.\n데이터 또는 와이파이 연결 상태를 확인해주세요."
            
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
