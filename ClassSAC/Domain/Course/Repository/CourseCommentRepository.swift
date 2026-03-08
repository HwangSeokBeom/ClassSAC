//
//  CourseCommentRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol CourseCommentRepository: AnyObject {

    func fetchComments(courseID: String) -> Single<[CourseComment]>
}
