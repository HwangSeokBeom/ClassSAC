//
//  CommentErrorMapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CommentErrorMapper {

    static func map(_ error: Error, action: CommentErrorAction) -> CommentError {
        if let commentError = error as? CommentError {
            return commentError
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

            case 410:
                switch action {
                case .fetch, .create:
                    return .courseNotFound
                case .update, .delete:
                    return .commentNotFound
                }

            case 445:
                switch action {
                case .update:
                    return .noEditPermission
                case .delete:
                    return .noDeletePermission
                case .fetch, .create:
                    return .forbidden
                }

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
