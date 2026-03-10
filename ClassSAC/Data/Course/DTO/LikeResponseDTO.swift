//
//  LikeResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

struct LikeResponseDTO: Decodable {
    let likeStatus: Bool

    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
