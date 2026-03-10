//
//  ProfileErrorMapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

enum ProfileErrorMapper {

    static func map(_ error: Error) -> ProfileError {
        if let profileError = error as? ProfileError {
            return profileError
        }

        guard let apiError = APIErrorMapperSupport.apiError(from: error) else {
            if error is DecodingError {
                return .decoding
            }

            return APIErrorMapperSupport.isNetworkError(error) ? .network : .unknown
        }

        switch apiError {
        case .statusCode(let statusCode, _):
            switch statusCode {
            case 400:
                return .invalidRequest
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 500...599:
                return .network
            default:
                return .unknown
            }

        case .underlying:
            return APIErrorMapperSupport.isNetworkError(error) ? .network : .unknown

        case .decoding:
            return .decoding

        case .invalidURL, .deallocated:
            return .unknown
        }
    }
}
