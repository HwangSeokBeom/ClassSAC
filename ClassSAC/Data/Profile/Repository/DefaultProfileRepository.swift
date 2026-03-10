//
//  DefaultProfileRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift

final class DefaultProfileRepository: ProfileRepository {

    private let profileRemoteDataSource: ProfileRemoteDataSource

    init(profileRemoteDataSource: ProfileRemoteDataSource) {
        self.profileRemoteDataSource = profileRemoteDataSource
    }

    func fetchMyProfile() -> Single<UserProfile> {
        profileRemoteDataSource
            .fetchMyProfile()
            .map { responseDTO in
                responseDTO.toEntity()
            }
            .catch { error in
                .error(ProfileErrorMapper.map(error))
            }
    }
}
