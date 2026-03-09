//
//  CommentRemoteDataSource.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class CommentRemoteDataSource {

    private let httpClient: ClassSACHTTPClienting

    init(httpClient: ClassSACHTTPClienting) {
        self.httpClient = httpClient
    }

    func fetchComments(courseID: String) -> Single<CommentListResponseDTO> {
        Single.create { [httpClient] single in
            httpClient.request(
                ClassSACAPI.comments(courseId: courseID),
                as: CommentListResponseDTO.self
            ) { result in
                switch result {
                case .success(let responseDTO):
                    single(.success(responseDTO))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func createComment(courseID: String, content: String) -> Single<CommentDTO> {
        Single.create { [httpClient] single in
            httpClient.request(
                ClassSACAPI.createComment(
                    courseId: courseID,
                    body: CreateCommentRequestDTO(content: content)
                ),
                as: CommentDTO.self
            ) { result in
                switch result {
                case .success(let responseDTO):
                    single(.success(responseDTO))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func updateComment(courseID: String, commentID: String, content: String) -> Single<CommentDTO> {
        Single.create { [httpClient] single in
            httpClient.request(
                ClassSACAPI.updateComment(
                    courseId: courseID,
                    commentId: commentID,
                    body: UpdateCommentRequestDTO(content: content)
                ),
                as: CommentDTO.self
            ) { result in
                switch result {
                case .success(let responseDTO):
                    single(.success(responseDTO))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func deleteComment(courseID: String, commentID: String) -> Single<Void> {
        Single.create { [httpClient] single in
            httpClient.requestVoid(
                ClassSACAPI.deleteComment(courseId: courseID, commentId: commentID)
            ) { result in
                switch result {
                case .success:
                    single(.success(()))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }
}
