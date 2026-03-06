//
//  JoinResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

extension JoinResponseDTO {
    func toEntity() -> UserSession {
        UserSession(
            userID: user_id,
            email: email,
            nick: nick,
            profileImage: nil,
            accessToken: nil
        )
    }
}
