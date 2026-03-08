import Foundation

extension CourseCommentDTO {

    func toEntity() -> CourseComment {

        CourseComment(
            id: commentID,
            content: content,
            createdAt: DateFormatterManager.iso8601.date(from: createdAt),
            writer: CourseCommentWriter(
                userID: creator.user_id,
                nick: creator.nick,
                profileImageURL: creator.profileImage
            )
        )
    }
}
