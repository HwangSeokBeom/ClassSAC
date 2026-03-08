//
//  CourseCommentListResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

struct CourseCommentListResponseDTO: Decodable {

    let data: [CourseCommentDTO]
}

struct CourseCommentDTO: Decodable {

    let commentID: String
    let content: String
    let createdAt: String
    let creator: CommentCreatorDTO

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content
        case createdAt = "created_at"
        case creator
    }
}
