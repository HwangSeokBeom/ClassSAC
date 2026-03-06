//
//  LoginResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

struct LoginResponseDTO: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
}
