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
        completion: @escaping (Result<UserSession, AuthError>) -> Void
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
                print("🔥 Join API Error:", error.debugMessage)
                completion(.failure(self.mapAuthError(error)))
            }
        }
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<UserSession, AuthError>) -> Void
    ) {
        authRemoteDataSource.login(
            email: email,
            password: password
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toEntity()))

            case .failure(let error):
                completion(.failure(self.mapAuthError(error)))
            }
        }
    }
}

private extension DefaultAuthRepository {

    func mapAuthError(_ error: ClassSACAPIError) -> AuthError {
        switch error {
        case .statusCode(let statusCode, _):
            switch statusCode {
            case 401:
                return .invalidCredential
            case 403:
                return .unauthorized
            case 409:
                return .duplicateEmail
            case 429:
                return .network
            case 500...599:
                return .network
            default:
                return .unknown
            }
            
        case .underlying(let underlyingError):
            if let urlError = underlyingError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet,
                     .timedOut,
                     .cannotFindHost,
                     .cannotConnectToHost,
                     .dnsLookupFailed:
                    return .network
                default:
                    return .unknown
                }
            }
            return .unknown

        case .invalidURL, .decoding, .deallocated:
            return .unknown
        }
    }
}
