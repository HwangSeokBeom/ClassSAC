//
//  DefaultFetchMyProfileUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift

final class DefaultFetchMyProfileUseCase: FetchMyProfileUseCase {

    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

    func execute() -> Single<UserProfile> {
        profileRepository.fetchMyProfile()
    }
}
