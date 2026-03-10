//
//  ProfileResponseDTO+Mapping.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

extension ProfileResponseDTO {

    func toEntity() -> UserProfile {
        UserProfile(
            userID: userID,
            email: email,
            nick: nick,
            profileImageURL: profileImage
        )
    }
}
