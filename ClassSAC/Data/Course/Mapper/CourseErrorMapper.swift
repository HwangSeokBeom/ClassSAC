//
//  CourseErrorMapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CourseErrorMapper {

    static func map(_ error: Error) -> CourseError {
        if let courseError = error as? CourseError {
            return courseError
        }

        guard let apiError = APIErrorMapperSupport.apiError(from: error) else {
            return APIErrorMapperSupport.isNetworkError(error) ? .network : .unknown
        }

        switch apiError {
        case .statusCode(let statusCode, _):
            switch statusCode {
            case 400:
                return .badRequest
            case 401:
                return .unauthorized
            case 403, 445:
                return .forbidden
            case 404, 410:
                return .notFound
            case 420:
                return .invalidSesacKey
            case 429:
                return .tooManyRequests
            case 500...599:
                return .serverError
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
