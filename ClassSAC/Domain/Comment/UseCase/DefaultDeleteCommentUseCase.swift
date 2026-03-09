//
//  DefaultDeleteCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultDeleteCommentUseCase: DeleteCommentUseCase {

    private let commentRepository: CommentRepository

    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }

    func execute(courseID: String, commentID: String) -> Single<Void> {
        commentRepository.deleteComment(courseID: courseID, commentID: commentID)
    }
}
