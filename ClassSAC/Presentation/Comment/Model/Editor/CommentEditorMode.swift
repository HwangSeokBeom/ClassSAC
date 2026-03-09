//
//  CommentEditorMode.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CommentEditorMode {
    case create(courseID: String)
    case edit(comment: Comment)

    var navigationTitle: String {
        switch self {
        case .create:
            return "댓글 작성"
        case .edit:
            return "댓글 수정"
        }
    }

    var confirmButtonTitle: String {
        switch self {
        case .create:
            return "확인"
        case .edit:
            return "확인"
        }
    }

    var initialContentText: String {
        switch self {
        case .create:
            return ""
        case .edit(let comment):
            return comment.content
        }
    }

    var courseID: String {
        switch self {
        case .create(let courseID):
            return courseID
        case .edit(let comment):
            return comment.courseID
        }
    }

    var editingCommentID: String? {
        switch self {
        case .create:
            return nil
        case .edit(let comment):
            return comment.id
        }
    }
}
