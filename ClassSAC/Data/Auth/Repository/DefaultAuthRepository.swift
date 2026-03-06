//
//  DefaultAuthRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import RxSwift

final class DefaultAuthRepository: AuthRepository {

    private let authRemoteDataSource: AuthRemoteDataSource

    init(authRemoteDataSource: AuthRemoteDataSource) {
        self.authRemoteDataSource = authRemoteDataSource
    }

    func join(email: String, password: String, nick: String) -> Single<UserSession> {
        Single.create { [weak self] single in
            guard let self else {
                single(.failure(ClassSACAPIError.deallocated))
                return Disposables.create()
            }

            self.authRemoteDataSource.join(
                email: email,
                password: password,
                nick: nick
            ) { result in
                switch result {
                case .success(let responseDTO):
                    single(.success(responseDTO.toEntity()))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func login(email: String, password: String) -> Single<UserSession> {
        Single.create { [weak self] single in
            guard let self else {
                single(.failure(ClassSACAPIError.deallocated))
                return Disposables.create()
            }

            self.authRemoteDataSource.login(
                email: email,
                password: password
            ) { result in
                switch result {
                case .success(let responseDTO):
                    single(.success(responseDTO.toEntity()))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }
}
