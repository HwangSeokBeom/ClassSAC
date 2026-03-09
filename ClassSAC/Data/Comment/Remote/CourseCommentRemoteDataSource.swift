//
//  CourseCommentRemoteDataSource.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class CourseCommentRemoteDataSource {

    private let httpClient: ClassSACHTTPClienting

    init(httpClient: ClassSACHTTPClienting) {
        self.httpClient = httpClient
    }

    func fetchComments(courseID: String) -> Single<CourseCommentListResponseDTO> {

        Single.create { [httpClient] single in

            httpClient.request(
                ClassSACAPI.comments(courseId: courseID),
                as: CourseCommentListResponseDTO.self
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
}
