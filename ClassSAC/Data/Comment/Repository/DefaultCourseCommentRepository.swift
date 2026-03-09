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
            .catch { error in
                .error(CommentErrorMapper.map(error, action: .fetch))
            }
    }

    func createComment(courseID: String, content: String) -> Single<Comment> {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedContent.isEmpty else {
            return .error(CommentError.emptyContent)
        }

        guard trimmedContent.count >= 2 else {
            return .error(CommentError.tooShortContent)
        }

        return remoteDataSource
            .createComment(courseID: courseID, content: trimmedContent)
            .map { [currentUserIDProvider] responseDTO in
                responseDTO.toEntity(
                    courseID: courseID,
                    currentUserID: currentUserIDProvider()
                )
            }
            .catch { error in
                .error(CommentErrorMapper.map(error, action: .create))
            }
    }

    func updateComment(courseID: String, commentID: String, content: String) -> Single<Comment> {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedContent.isEmpty else {
            return .error(CommentError.emptyContent)
        }

        guard trimmedContent.count >= 2 else {
            return .error(CommentError.tooShortContent)
        }

        return remoteDataSource
            .updateComment(courseID: courseID, commentID: commentID, content: trimmedContent)
            .map { [currentUserIDProvider] responseDTO in
                responseDTO.toEntity(
                    courseID: courseID,
                    currentUserID: currentUserIDProvider()
                )
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
