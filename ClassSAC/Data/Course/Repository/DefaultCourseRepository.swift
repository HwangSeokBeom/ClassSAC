//
//  DefaultCourseRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation
import RxSwift

final class DefaultCourseRepository: CourseRepository {

    private let remoteDataSource: CourseRemoteDataSource

    init(remoteDataSource: CourseRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchCourses() -> Single<[Course]> {
        remoteDataSource
            .fetchCourses()
            .map { response in
                response.data.map { $0.toEntity() }
            }
            .catch { error in
                .error(CourseErrorMapper.map(error))
            }
    }

    func fetchCourseDetail(courseID: String) -> Single<CourseDetail> {
        remoteDataSource
            .fetchCourseDetail(courseID: courseID)
            .map { responseDTO in
                responseDTO.toEntity()
            }
            .catch { error in
                .error(CourseErrorMapper.map(error))
            }
    }

    func searchCourses(query: String) -> Single<[Course]> {
        remoteDataSource
            .searchCourses(query: query)
            .map { responseDTO in
                responseDTO.data.map { $0.toEntity() }
            }
            .catch { error in
                .error(CourseErrorMapper.map(error))
            }
    }

    func updateCourseLikeStatus(
        courseID: String,
        likeStatus: Bool
    ) -> Single<CourseLikeResult> {
        remoteDataSource
            .updateCourseLikeStatus(courseID: courseID, likeStatus: likeStatus)
            .map { responseDTO in
                CourseLikeResult(
                    courseID: courseID,
                    likeStatus: responseDTO.likeStatus
                )
            }
            .catch { error in
                .error(CourseErrorMapper.map(error))
            }
    }
}
