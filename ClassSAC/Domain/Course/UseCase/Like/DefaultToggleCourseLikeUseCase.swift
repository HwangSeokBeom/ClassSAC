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
    private let courseLikeStatusNotifier: CourseLikeStatusBroadcasting

    init(
        courseRepository: CourseRepository,
        courseLikeStatusNotifier: CourseLikeStatusBroadcasting
    ) {
        self.courseRepository = courseRepository
        self.courseLikeStatusNotifier = courseLikeStatusNotifier
    }

    func execute(courseID: String, isLiked: Bool) -> Single<Void> {
        courseRepository.toggleCourseLike(
            courseID: courseID,
            isLiked: isLiked
        )
        .do(onSuccess: { [weak self] _ in
            self?.courseLikeStatusNotifier.post(
                courseID: courseID,
                isLiked: isLiked
            )
        })
    }
}
