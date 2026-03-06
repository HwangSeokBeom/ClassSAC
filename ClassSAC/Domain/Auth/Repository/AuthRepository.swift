//
//  AuthRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import RxSwift

protocol AuthRepository {
    func join(email: String, password: String, nick: String) -> Single<UserSession>
    func login(email: String, password: String) -> Single<UserSession>
}
