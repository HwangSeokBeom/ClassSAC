//
//  AuthRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

protocol AuthRepository {
    func join(
        email: String,
        password: String,
        nick: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    )

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    )
}
