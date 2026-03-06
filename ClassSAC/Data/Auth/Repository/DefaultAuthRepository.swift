//
//  DefaultAuthRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {

    private let authRemoteDataSource: AuthRemoteDataSource

    init(authRemoteDataSource: AuthRemoteDataSource) {
        self.authRemoteDataSource = authRemoteDataSource
    }

    func join(
        email: String,
        password: String,
        nick: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    ) {
        authRemoteDataSource.join(
            email: email,
            password: password,
            nick: nick
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toEntity()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    ) {
        authRemoteDataSource.login(
            email: email,
            password: password
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toEntity()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
