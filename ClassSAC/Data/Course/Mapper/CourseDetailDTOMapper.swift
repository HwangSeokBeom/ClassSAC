//
//  CourseDetailResponseDTO+Mapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension CourseDetailResponseDTO {

    func toEntity() -> CourseDetail {
        CourseDetail(
            id: classID,
            category: CourseCategory(rawValue: category) ?? .etc,
            title: title,
            description: description,
            price: price,
            salePrice: salePrice,
            location: location,
            date: date,
            capacity: capacity,
            imageURLs: imageURLs,
            createdAt: createdAt.flatMap {
                ISO8601DateFormatter().date(from: $0)
            },
            isLiked: isLiked,
            creator: creator.toEntity()
        )
    }
}
