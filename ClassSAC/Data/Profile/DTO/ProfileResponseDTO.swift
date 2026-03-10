//
//  ProfileResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let userID: String
    let email: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nick
        case profileImage
    }
}
