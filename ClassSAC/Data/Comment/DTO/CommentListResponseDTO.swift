//
//  CourseCommentListResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CommentListResponseDTO: Decodable {
    let data: [CommentDTO]
}

struct CommentDTO: Decodable {
    let commentID: String
    let courseID: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let creator: CommentCreatorDTO
    let isMine: Bool

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case courseID = "course_id"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case creator
        case isMine = "is_mine"
    }
}

struct CommentCreatorDTO: Decodable {
    let userID: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}
