//
//  ProfileRemoteDataSource.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift

final class ProfileRemoteDataSource {

    private let httpClient: ClassSACHTTPClienting

    init(httpClient: ClassSACHTTPClienting) {
        self.httpClient = httpClient
    }

    func fetchMyProfile() -> Single<ProfileResponseDTO> {
        Single.create { [httpClient] single in
            httpClient.request(
                ClassSACAPI.myProfile,
                as: ProfileResponseDTO.self
            ) { result in
                switch result {
                case .success(let responseDTO):
                    single(.success(responseDTO))

                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create()
        }
    }
}
