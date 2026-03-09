//
//  FetchCommentsUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol FetchCommentsUseCase {
    func execute(courseID: String) -> Single<[Comment]>
}
