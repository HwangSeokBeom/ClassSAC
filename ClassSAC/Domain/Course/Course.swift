//
//  Course.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

struct Course {
    let courseID: String
    let title: String
    let category: CourseCategory
    let thumbnailImageURLString: String?
    let originalPrice: Int
    let discountPrice: Int?
    let isFree: Bool
    let isLiked: Bool
    let instructorName: String?
    let updatedAt: Date?

    var effectivePrice: Int {
        if isFree {
            return 0
        }

        return discountPrice ?? originalPrice
    }

    var hasDiscount: Bool {
        guard let discountPrice else { return false }
        return discountPrice < originalPrice
    }
}
