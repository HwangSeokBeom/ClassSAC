//
//  DefaultToggleCourseLikeUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift

final class DefaultToggleCourseLikeUseCase: ToggleCourseLikeUseCase {

    private let courseRepository: CourseRepository

    init(courseRepository: CourseRepository) {
        self.courseRepository = courseRepository
    }

    func execute(courseID: String, isLiked: Bool) -> Single<Void> {
        courseRepository.toggleCourseLike(
            courseID: courseID,
            isLiked: isLiked
        )
    }
}
