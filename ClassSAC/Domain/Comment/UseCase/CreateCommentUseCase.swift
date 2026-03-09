//
//  CreateCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol CreateCommentUseCase {
    func execute(courseID: String, content: String) -> Single<Comment>
}
