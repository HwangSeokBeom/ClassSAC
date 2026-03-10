//
//  ToggleCourseLikeUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift

protocol ToggleCourseLikeUseCase {
    func execute(courseID: String, likeStatus: Bool) -> Single<CourseLikeResult>
}
