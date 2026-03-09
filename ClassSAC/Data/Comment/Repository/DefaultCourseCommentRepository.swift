//
//  DefaultCommentRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultCommentRepository: CommentRepository {

    private let remoteDataSource: CommentRemoteDataSource
    private let currentUserIDProvider: () -> String?

    init(
        remoteDataSource: CommentRemoteDataSource,
        currentUserIDProvider: @escaping () -> String?
    ) {
        self.remoteDataSource = remoteDataSource
        self.currentUserIDProvider = currentUserIDProvider
    }

    func fetchComments(courseID: String) -> Single<[Comment]> {
        remoteDataSource
            .fetchComments(courseID: courseID)
            .map { [currentUserIDProvider] responseDTO in
                let currentUserID = currentUserIDProvider()
                return responseDTO.data.map {
                    $0.toEntity(courseID: courseID, currentUserID: currentUserID)
                }
            }
    }

    func createComment(courseID: String, content: String) -> Single<Comment> {
        remoteDataSource
            .createComment(courseID: courseID, content: content)
            .map { [currentUserIDProvider] responseDTO in
                responseDTO.toEntity(
                    courseID: courseID,
                    currentUserID: currentUserIDProvider()
                )
            }
    }

    func updateComment(courseID: String, commentID: String, content: String) -> Single<Comment> {
        remoteDataSource
            .updateComment(courseID: courseID, commentID: commentID, content: content)
            .map { [currentUserIDProvider] responseDTO in
                responseDTO.toEntity(
                    courseID: courseID,
                    currentUserID: currentUserIDProvider()
                )
            }
    }

    func deleteComment(courseID: String, commentID: String) -> Single<Void> {
        remoteDataSource.deleteComment(courseID: courseID, commentID: commentID)
    }
}
