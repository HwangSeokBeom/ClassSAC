//
//  CommentListResponseDTO.swift
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
    let content: String
    let createdAt: String?
    let creator: CommentCreatorDTO

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content
        case createdAt = "created_at"
        case creator
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
