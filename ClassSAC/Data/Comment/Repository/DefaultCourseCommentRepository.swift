//
//  DefaultCourseCommentRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultCourseCommentRepository: CourseCommentRepository {

    private let remoteDataSource: CourseCommentRemoteDataSource

    init(remoteDataSource: CourseCommentRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchComments(courseID: String) -> Single<[CourseComment]> {
        remoteDataSource
            .fetchComments(courseID: courseID)
            .map { responseDTO in
                responseDTO.data.map { $0.toEntity() }
            }
            .catch { error in
                Single.error(error)
            }
    }
}
