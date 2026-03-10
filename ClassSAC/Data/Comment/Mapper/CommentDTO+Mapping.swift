//
//  CommentDTO+Mapping.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension CommentDTO {

    func toEntity(courseID: String) -> Comment {
        Comment(
            id: commentID,
            courseID: courseID,
            content: content,
            createdAt: DateParser.parseOptionalISO8601(createdAt),
            writer: CommentWriter(
                userID: creator.userID,
                nickname: creator.nick,
                profileImageURL: creator.profileImage
            )
        )
    }
}
