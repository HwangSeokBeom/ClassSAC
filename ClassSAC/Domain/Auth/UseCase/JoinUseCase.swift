//
//  JoinUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import RxSwift

protocol JoinUseCase: AnyObject {
    func execute(email: String, password: String, nick: String) -> Single<UserSession>
}
