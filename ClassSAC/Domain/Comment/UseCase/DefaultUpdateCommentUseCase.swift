//
//  DefaultUpdateCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultUpdateCommentUseCase: UpdateCommentUseCase {

    private enum Constant {
        static let minimumContentCount = 2
        static let maximumContentCount = 200
    }

    private let commentRepository: CommentRepository

    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }

    func execute(courseID: String, commentID: String, content: String) -> Single<Comment> {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedContent.isEmpty else {
            return .error(CommentError.emptyContent)
        }

        guard trimmedContent.count >= Constant.minimumContentCount else {
            return .error(CommentError.tooShortContent)
        }

        guard trimmedContent.count <= Constant.maximumContentCount else {
            return .error(CommentError.tooLongContent)
        }

        return commentRepository.updateComment(
            courseID: courseID,
            commentID: commentID,
            content: trimmedContent
        )
    }
}
