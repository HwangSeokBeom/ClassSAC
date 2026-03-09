//
//  Comment.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct Comment {
    let id: String
    let courseID: String
    let content: String
    let createdAt: Date?
    let writer: CommentWriter
}

struct CommentWriter {
    let userID: String
    let nickname: String
    let profileImageURL: String?
}
