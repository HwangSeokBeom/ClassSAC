//
//  DefaultCreateCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultCreateCommentUseCase: CreateCommentUseCase {

    private let commentRepository: CommentRepository

    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }

    func execute(courseID: String, content: String) -> Single<Comment> {
        commentRepository.createComment(courseID: courseID, content: content)
    }
}
