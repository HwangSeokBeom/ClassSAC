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

    func execute(courseID: String, likeStatus: Bool) -> Single<CourseLikeResult> {
        courseRepository
            .updateCourseLikeStatus(
                courseID: courseID,
                likeStatus: likeStatus
            )
            .do(onSuccess: { [weak self] result in
                self?.courseLikeStatusNotifier.post(
                    courseID: result.courseID,
                    likeStatus: result.likeStatus
                )
            })
    }
}
