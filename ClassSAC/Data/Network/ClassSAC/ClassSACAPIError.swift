//
//  ClassSACAPIError.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

import Foundation
import Alamofire

enum ClassSACAPIError: AppError {
    case invalidURL
    case statusCode(Int, message: String?)
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
            case 400: return "필수값을 채워주세요. (400)"
            case 401: return "인증할 수 없는 액세스 토큰입니다. 다시 로그인해주세요. (401)"
            case 403: return "접근 권한이 없습니다. (403)"
            case 409: return "이미 가입된 유저입니다. (409)"
            case 410: return "요청한 리소스를 찾을 수 없습니다. (410)"
            case 420: return "SesacKey가 없거나 올바르지 않습니다. (420)"
            case 429: return "과호출입니다. 잠시 후 다시 시도해주세요. (429)"
            case 444: return "비정상 URL 요청입니다. (444)"
            case 445: return "권한이 없습니다. 작성자만 수정/삭제할 수 있습니다. (445)"
            case 500...599: return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요. (\(code))"
            default: return "네트워크 오류가 발생했습니다. (\(code))"
            }

        case .decoding:
            return "데이터 처리 중 오류가 발생했습니다."

        case .underlying(let error):
            if let urlError = error as? URLError {
                return Self.map(urlError)
            }
            if let afError = error as? AFError,
               let urlError = afError.underlyingError as? URLError {
                return Self.map(urlError)
            }
            return (error as NSError).localizedDescription
        }
    }

    var debugMessage: String {
        switch self {
        case .invalidURL:
            return "invalidURL"

        case .statusCode(let code, let message):
            if let message { return "HTTP statusCode=\(code), message=\(message)" }
            return "HTTP statusCode=\(code)"

        case .decoding(let error):
            return "decoding error: \(error)"

        case .underlying(let error):
            return "underlying error: \(error)"
        }
    }
}

private extension ClassSACAPIError {
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
