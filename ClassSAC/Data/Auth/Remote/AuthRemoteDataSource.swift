//
//  AuthRemoteDataSource.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class AuthRemoteDataSource {

    private let httpClient: ClassSACHTTPClienting
    private let accessTokenStore: AccessTokenStoring

    init(httpClient: ClassSACHTTPClienting, accessTokenStore: AccessTokenStoring) {
        self.httpClient = httpClient
        self.accessTokenStore = accessTokenStore
    }

    func join(
        email: String,
        password: String,
        nick: String,
        completion: @escaping (Result<JoinResponseDTO, ClassSACAPIError>) -> Void
    ) {
        httpClient.request(
            ClassSACAPI.join(email: email, password: password, nick: nick),
            as: JoinResponseDTO.self,
            completion: completion
        )
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponseDTO, ClassSACAPIError>) -> Void
    ) {
        httpClient.request(
            ClassSACAPI.login(email: email, password: password),
            as: LoginResponseDTO.self
        ) { [weak self] result in
            if case .success(let response) = result {
                self?.accessTokenStore.save(accessToken: response.accessToken)
            }
            completion(result)
        }
    }
}
