//
//  FetchCourseDetailUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol FetchCourseDetailUseCase {
    func execute(courseID: String) -> Single<Course>
}
