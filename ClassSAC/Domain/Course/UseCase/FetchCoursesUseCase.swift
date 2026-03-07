//
//  FetchCoursesUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift

protocol FetchCoursesUseCase: AnyObject {
    func execute() -> Single<[Course]>
}
