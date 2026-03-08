//
//  CourseCommentDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

extension CourseCommentDTO {

    func toEntity() -> CourseComment {

        CourseComment(
            id: commentID,
            content: content,
            createdAt: ISO8601DateFormatter().date(from: createdAt),
            writer: CourseCommentWriter(
                userID: creator.userID,
                nick: creator.nick,
                profileImageURL: creator.profileImage
            )
        )
    }
}
