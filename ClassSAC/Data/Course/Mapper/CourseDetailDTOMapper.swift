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
            createdAt: DateParser.parseOptionalISO8601(createdAt),
            isLiked: isLiked,
            creator: creator.toEntity()
        )
    }
}
