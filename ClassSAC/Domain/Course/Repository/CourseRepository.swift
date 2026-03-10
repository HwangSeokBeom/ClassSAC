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
    func fetchCourseDetail(courseID: String) -> Single<CourseDetail>
    func searchCourses(query: String) -> Single<[Course]>
    func updateCourseLikeStatus(courseID: String, likeStatus: Bool) -> Single<CourseLikeResult>
}
