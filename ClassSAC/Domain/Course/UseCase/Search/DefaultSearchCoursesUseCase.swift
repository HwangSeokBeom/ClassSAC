//
//  DefaultSearchCoursesUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import RxSwift

final class DefaultSearchCoursesUseCase: SearchCoursesUseCase {

    private let courseRepository: CourseRepository

    init(courseRepository: CourseRepository) {
        self.courseRepository = courseRepository
    }

    func execute(query: String) -> Single<[Course]> {
        courseRepository.searchCourses(query: query)
    }
}
