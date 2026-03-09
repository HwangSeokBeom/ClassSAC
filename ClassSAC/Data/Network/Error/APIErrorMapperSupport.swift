//
//  APIErrorMapperSupport.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum APIErrorMapperSupport {

    static func apiError(from error: Error) -> ClassSACAPIError? {
        error as? ClassSACAPIError
    }

    static func isNetworkError(_ error: Error) -> Bool {
        if let apiError = error as? ClassSACAPIError {
            switch apiError {
            case .underlying(let underlyingError):
                return isNetworkURLError(underlyingError)
            default:
                return false
            }
        }

        return isNetworkURLError(error)
    }

    static func isNetworkURLError(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else {
            return false
        }

        switch urlError.code {
        case .notConnectedToInternet,
             .timedOut,
             .cannotFindHost,
             .cannotConnectToHost,
             .dnsLookupFailed:
            return true

        default:
            return false
        }
    }
}
