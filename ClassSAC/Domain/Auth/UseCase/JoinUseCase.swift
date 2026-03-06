//
//  JoinUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

protocol JoinUseCase: AnyObject {
    func execute(
        email: String,
        password: String,
        nick: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    )
}
