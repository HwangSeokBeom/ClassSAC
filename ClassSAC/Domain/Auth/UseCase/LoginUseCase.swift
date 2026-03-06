//
//  LoginUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

protocol LoginUseCase {
    func execute(
        email: String,
        password: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    )
}
