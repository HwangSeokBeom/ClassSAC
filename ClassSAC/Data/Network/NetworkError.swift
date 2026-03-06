//
//  NetworkError.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

import Foundation
import Alamofire

enum NetworkError: AppError {
    case invalidURL
    case statusCode(Int, message: String? = nil)
    case decoding(Error)
    case underlying(Error)

    var userMessage: String {
        switch self {
        case .invalidURL:
            return "요청 URL이 올바르지 않습니다."

        case .statusCode(let code, let message):
            if let message, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "\(message) (\(code))"
            }
            switch code {
            case 400: return "잘못된 요청입니다. (400)"
            case 401: return "인증이 필요합니다. API 키를 확인해주세요. (401)"
            case 403: return "접근 권한이 없습니다. (403)"
            case 404: return "요청한 정보를 찾을 수 없습니다. (404)"
            case 429: return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요. (429)"
            case 500...599: return "서버에 문제가 있습니다. 잠시 후 다시 시도해주세요. (\(code))"
            default: return "네트워크 오류가 발생했습니다. (\(code))"
            }

        case .decoding:
            return "데이터 처리 중 오류가 발생했습니다."

        case .underlying(let error):
            if let urlError = error as? URLError {
                return NetworkError.map(urlError)
            }

            if let afError = error as? AFError,
               let urlError = afError.underlyingError as? URLError {
                return NetworkError.map(urlError)
            }

            return (error as NSError).localizedDescription
        }
    }

    var debugMessage: String {
        switch self {
        case .invalidURL:
            return "invalidURL"

        case .statusCode(let code, let message):
            if let message {
                return "HTTP statusCode=\(code), message=\(message)"
            }
            return "HTTP statusCode=\(code)"

        case .decoding(let error):
            return "decoding error: \(error)"

        case .underlying(let error):
            return "underlying error: \(error)"
        }
    }
}

private extension NetworkError {
    static func map(_ urlError: URLError) -> String {
        switch urlError.code {
        case .notConnectedToInternet:
            return "인터넷 연결이 없습니다. 네트워크 상태를 확인해주세요."
        case .timedOut:
            return "요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요."
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return "서버에 연결할 수 없습니다. 네트워크 상태를 확인해주세요."
        default:
            return "네트워크 오류가 발생했습니다."
        }
    }
}
