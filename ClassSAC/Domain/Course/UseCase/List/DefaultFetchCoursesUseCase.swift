//
//  DefaultFetchCoursesUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift

final class DefaultFetchCoursesUseCase: FetchCoursesUseCase {

    private let courseRepository: CourseRepository

    init(courseRepository: CourseRepository) {
        self.courseRepository = courseRepository
    }

    func execute() -> Single<[Course]> {
        courseRepository.fetchCourses()
    }
}
