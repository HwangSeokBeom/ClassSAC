//
//  DefaultFetchCourseDetailUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

final class DefaultFetchCourseDetailUseCase: FetchCourseDetailUseCase {

    private let courseRepository: CourseRepository

    init(courseRepository: CourseRepository) {
        self.courseRepository = courseRepository
    }

    func execute(courseID: String) -> Single<CourseDetail> {
        courseRepository.fetchCourseDetail(courseID: courseID)
    }
}
