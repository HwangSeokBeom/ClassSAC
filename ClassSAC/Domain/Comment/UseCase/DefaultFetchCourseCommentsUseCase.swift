//
//  DefaultFetchCommentsUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultFetchCommentsUseCase: FetchCommentsUseCase {

    private let repository: CommentRepository

    init(repository: CommentRepository) {
        self.repository = repository
    }

    func execute(courseID: String) -> Single<[Comment]> {
        repository.fetchComments(courseID: courseID)
    }
}
