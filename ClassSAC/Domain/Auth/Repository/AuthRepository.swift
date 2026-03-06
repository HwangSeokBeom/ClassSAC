//
//  AuthRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

protocol AuthRepository: AnyObject {
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<UserSession, AuthError>) -> Void
    )

    func join(
        email: String,
        password: String,
        nick: String,
        completion: @escaping (Result<UserSession, AuthError>) -> Void
    )
}
