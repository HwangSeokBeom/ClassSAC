//
//  CourseDTO+Mapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation

extension CourseDTO {

    func toEntity() -> Course {
        Course(
            id: classID,
            category: CourseCategory(rawValue: category) ?? .etc,
            title: title,
            description: description,
            price: price,
            salePrice: salePrice,
            thumbnailURL: imageURL,
            imageURLs: imageURLs ?? [],
            createdAt: DateParser.parseOptionalISO8601(createdAt),
            isLiked: isLiked,
            creatorNick: creator.nick
        )
    }
}
