//
//  CommentListAlert.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CommentListAlert {
    case delete(commentID: String)

    var title: String {
        switch self {
        case .delete:
            return "댓글 삭제"
        }
    }

    var message: String {
        switch self {
        case .delete:
            return "댓글을 삭제하시겠습니까?"
        }
    }

    var confirmButtonTitle: String {
        switch self {
        case .delete:
            return "삭제"
        }
    }

    var cancelButtonTitle: String {
        switch self {
        case .delete:
            return "취소"
        }
    }
}
