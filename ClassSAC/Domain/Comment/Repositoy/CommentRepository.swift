//
//  CommentRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol CommentRepository {
    func fetchComments(courseID: String) -> Single<[Comment]>
    func createComment(courseID: String, content: String) -> Single<Comment>
    func updateComment(commentID: String, content: String) -> Single<Comment>
    func deleteComment(commentID: String) -> Single<Void>
}
