//
//  CourseListResponseDTO.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

struct CourseListResponseDTO: Decodable {
    let data: [CourseDTO]
}

struct CourseDTO: Decodable {
    let class_id: String
    let category: Int
    let title: String
    let description: String?
    let price: Int?
    let sale_price: Int?
    let image_url: String?
    let image_urls: [String]?
    let created_at: String
    let is_liked: Bool
    let creator: CourseCreatorDTO
}

struct CourseCreatorDTO: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
