//
//  DefaultFetchCommentsUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultFetchCommentsUseCase: FetchCommentsUseCase {

    private let commentRepository: CommentRepository

    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }

    func execute(courseID: String) -> Single<[Comment]> {
        commentRepository.fetchComments(courseID: courseID)
    }
}
