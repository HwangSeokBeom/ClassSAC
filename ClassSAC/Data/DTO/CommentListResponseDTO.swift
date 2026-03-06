//
//  CommentListResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

struct CommentListResponseDTO: Decodable {
    let data: [CommentDTO]
}

struct CommentDTO: Decodable {
    let comment_id: String
    let content: String
    let created_at: String
    let creator: CommentCreatorDTO
}

struct CommentCreatorDTO: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
