//
//  DefaultUpdateCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultUpdateCommentUseCase: UpdateCommentUseCase {

    private let commentRepository: CommentRepository

    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }

    func execute(courseID: String, commentID: String, content: String) -> Single<Comment> {
        commentRepository.updateComment(courseID: courseID, commentID: commentID, content: content)
    }
}
