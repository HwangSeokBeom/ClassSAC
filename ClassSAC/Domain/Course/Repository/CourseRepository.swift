//
//  CourseRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift

protocol CourseRepository: AnyObject {
    func fetchCourses() -> Single<[Course]>
    func searchCourses(query: String) -> Single<[Course]>
    func toggleCourseLike(courseID: String, isLiked: Bool) -> Single<Void>
}
