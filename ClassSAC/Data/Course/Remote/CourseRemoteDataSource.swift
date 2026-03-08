//
//  CourseRemoteDataSource.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift

final class CourseRemoteDataSource {

    private let httpClient: ClassSACHTTPClienting

    init(httpClient: ClassSACHTTPClienting) {
        self.httpClient = httpClient
    }

    func fetchCourses() -> Single<CourseListResponseDTO> {
        Single<CourseListResponseDTO>.create { [httpClient] single in
            httpClient.request(
                ClassSACAPI.courses(query: nil),
                as: CourseListResponseDTO.self
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

    func searchCourses(query: String) -> Single<CourseListResponseDTO> {
        Single<CourseListResponseDTO>.create { [httpClient] single in
            let searchCoursesQuery = SearchCoursesQuery(title: query)

            httpClient.request(
                ClassSACAPI.searchCourses(query: searchCoursesQuery),
                as: CourseListResponseDTO.self
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

    func toggleCourseLike(
        courseID: String,
        isLiked: Bool
    ) -> Single<Void> {
        Single<Void>.create { [httpClient] single in
            httpClient.requestVoid(
                ClassSACAPI.likeCourse(courseId: courseID, likeStatus: isLiked)
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
