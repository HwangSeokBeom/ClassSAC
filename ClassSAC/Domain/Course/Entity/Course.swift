//
//  Course.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

struct Course {
    let id: String
    let category: CourseCategory
    let title: String
    let description: String?
    let price: Int?
    let salePrice: Int?
    let thumbnailURL: String?
    let imageURLs: [String]
    let createdAt: Date?
    let isLiked: Bool
    let creatorNick: String

    var coursePrice: CoursePrice {
        CoursePrice(price: price, salePrice: salePrice)
    }
}
