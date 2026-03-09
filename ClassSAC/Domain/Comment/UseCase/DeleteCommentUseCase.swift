//
//  DeleteCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol DeleteCommentUseCase {
    func execute(courseID: String, commentID: String) -> Single<Void>
}
