//
//  UpdateCommentUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift

protocol UpdateCommentUseCase {
    func execute(commentID: String, content: String) -> Single<Comment>
}
