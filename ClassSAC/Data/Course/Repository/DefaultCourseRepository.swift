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
    }

    func toggleCourseLike(
        courseID: String,
        isLiked: Bool
    ) -> Single<Void> {

        remoteDataSource.toggleCourseLike(
            courseID: courseID,
            isLiked: isLiked
        )
    }
}
