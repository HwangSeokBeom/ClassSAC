//
//  MyProfileResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

struct MyProfileResponseDTO: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
}
