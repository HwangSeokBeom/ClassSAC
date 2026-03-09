//
//  AuthErrorMapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum AuthErrorMapper {

    static func map(_ error: Error) -> AuthError {
        if let authError = error as? AuthError {
            return authError
        }

        guard let apiError = APIErrorMapperSupport.apiError(from: error) else {
            return APIErrorMapperSupport.isNetworkError(error) ? .network : .unknown
        }

        switch apiError {
        case .statusCode(let statusCode, _):
            switch statusCode {
            case 401:
                return .invalidCredential
            case 403:
                return .unauthorized
            case 409:
                return .duplicateEmail
            case 429:
                return .network
            case 500...599:
                return .network
            default:
                return .unknown
            }

        case .underlying:
            return APIErrorMapperSupport.isNetworkError(error) ? .network : .unknown

        case .invalidURL, .decoding, .deallocated:
            return .unknown
        }
    }
}
