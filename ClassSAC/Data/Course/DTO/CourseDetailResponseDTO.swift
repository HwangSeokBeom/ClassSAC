//
//  CourseDetailResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CourseDetailResponseDTO: Decodable {
    let classID: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let location: String?
    let date: String?
    let capacity: Int?
    let imageURLs: [String]
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
        case location
        case date
        case capacity
        case imageURLs = "image_urls"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }
}
