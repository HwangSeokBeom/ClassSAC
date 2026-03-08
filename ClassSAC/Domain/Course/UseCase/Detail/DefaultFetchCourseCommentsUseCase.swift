//
//  DefaultFetchCourseCommentsUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultFetchCourseCommentsUseCase: FetchCourseCommentsUseCase {

    private let courseCommentRepository: CourseCommentRepository

    init(courseCommentRepository: CourseCommentRepository) {
        self.courseCommentRepository = courseCommentRepository
    }

    func execute(courseID: String) -> Single<[CourseComment]> {
        courseCommentRepository.fetchComments(courseID: courseID)
    }
}
