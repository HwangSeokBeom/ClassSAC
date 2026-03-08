//
//  FetchCourseCommentsUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol FetchCourseCommentsUseCase {
    func execute(courseID: String) -> Single<[CourseComment]>
}
