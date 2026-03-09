//
//  CommentError.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CommentError: Error {
    case emptyContent
    case tooShortContent
    case invalidRequest
    case unauthorized
    case forbidden
    case courseNotFound
    case commentNotFound
    case noEditPermission
    case noDeletePermission
    case decoding
    case network
    case unknown
}

extension CommentError {

    var userMessage: String {
        switch self {
        case .emptyContent:
            return "댓글 내용을 입력해주세요."

        case .tooShortContent:
            return "댓글은 2글자 이상 입력해주세요."

        case .invalidRequest:
            return "입력값을 다시 확인해주세요."

        case .unauthorized:
            return "로그인이 만료되었습니다. 다시 로그인해주세요."

        case .forbidden:
            return "접근 권한이 없습니다."

        case .courseNotFound:
            return "클래스 정보를 찾을 수 없습니다."

        case .commentNotFound:
            return "댓글을 찾을 수 없습니다."

        case .noEditPermission:
            return "댓글 수정 권한이 없습니다."

        case .noDeletePermission:
            return "댓글 삭제 권한이 없습니다."

        case .decoding:
            return "댓글 정보를 불러오는 중 문제가 발생했습니다."

        case .network:
            return "네트워크 상태를 확인해주세요."

        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
