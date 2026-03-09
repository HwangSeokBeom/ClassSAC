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

    init(remoteDataSource: CommentRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchComments(courseID: String) -> Single<[Comment]> {
        remoteDataSource
            .fetchComments(courseID: courseID)
            .map { responseDTO in
                responseDTO.data.map {
                    $0.toEntity(courseID: courseID)
                }
            }
            .catch { error in
                .error(CommentErrorMapper.map(error, action: .fetch))
            }
    }

    func createComment(courseID: String, content: String) -> Single<Comment> {
        remoteDataSource
            .createComment(courseID: courseID, content: content)
            .map { responseDTO in
                responseDTO.toEntity(courseID: courseID)
            }
            .catch { error in
                .error(CommentErrorMapper.map(error, action: .create))
            }
    }

    func updateComment(courseID: String, commentID: String, content: String) -> Single<Comment> {
        remoteDataSource
            .updateComment(courseID: courseID, commentID: commentID, content: content)
            .map { responseDTO in
                responseDTO.toEntity(courseID: courseID)
            }
            .catch { error in
                .error(CommentErrorMapper.map(error, action: .update))
            }
    }

    func deleteComment(courseID: String, commentID: String) -> Single<Void> {
        remoteDataSource
            .deleteComment(courseID: courseID, commentID: commentID)
            .catch { error in
                .error(CommentErrorMapper.map(error, action: .delete))
            }
    }
}
