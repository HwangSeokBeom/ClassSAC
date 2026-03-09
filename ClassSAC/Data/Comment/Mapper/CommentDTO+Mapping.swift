//
//  CommentDTO+Mapping.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension CommentDTO {

    func toEntity() -> Comment {
        Comment(
            id: commentID,
            courseID: courseID,
            content: content,
            createdAt: DateFormatterManager.iso8601.date(from: createdAt),
            updatedAt: DateFormatterManager.iso8601.date(from: updatedAt),
            writer: CommentWriter(
                userID: creator.userID,
                nickname: creator.nick,
                profileImageURL: creator.profileImage
            ),
            isWrittenByCurrentUser: isMine
        )
    }
}
