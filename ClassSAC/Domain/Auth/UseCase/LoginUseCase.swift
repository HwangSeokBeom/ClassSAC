//
//  LoginUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import RxSwift

protocol LoginUseCase: AnyObject {
    func execute(email: String, password: String) -> Single<UserSession>
}
