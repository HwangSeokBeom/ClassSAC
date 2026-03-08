//
//  CourseDetail.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CourseDetail {
    let id: String
    let category: CourseCategory
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let location: String?
    let date: String?
    let capacity: Int?
    let imageURLs: [String]
    let createdAt: Date?
    let isLiked: Bool
    let creator: CourseDetailCreator
}

struct CourseDetailCreator {
    let userID: String
    let nick: String
    let profileImageURL: String?
}
