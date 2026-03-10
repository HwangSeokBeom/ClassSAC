//
//  CourseListResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

struct CourseListResponseDTO: Decodable {
    let data: [CourseDTO]
}

struct CourseDTO: Decodable {
    let classID: String
    let category: Int
    let title: String
    let description: String?
    let price: Int?
    let salePrice: Int?
    let imageURL: String?
    let imageURLs: [String]?
    let createdAt: String?
    let isLiked: Bool
    let creator: CourseCreatorDTO

    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case category
        case title
        case description
        case price
        case salePrice = "sale_price"
        case imageURL = "image_url"
        case imageURLs = "image_urls"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }
}

struct CourseCreatorDTO: Decodable {
    let userID: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}
