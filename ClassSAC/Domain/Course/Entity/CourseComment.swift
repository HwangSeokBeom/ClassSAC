//
//  CourseComment.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CourseComment {
    let id: String
    let content: String
    let createdAt: Date?
    let writer: CourseCommentWriter
}

struct CourseCommentWriter {
    let userID: String
    let nick: String
    let profileImageURL: String?
}
