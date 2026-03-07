//
//  CourseDTO+Mapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation

extension CourseDTO {

    func toEntity() -> Course {

        let dateFormatter = ISO8601DateFormatter()

        return Course(
            id: classID,
            category: category,
            title: title,
            description: description,
            price: price,
            salePrice: salePrice,
            thumbnailURL: imageURL,
            imageURLs: imageURLs ?? [],
            createdAt: dateFormatter.date(from: createdAt) ?? Date(),
            isLiked: isLiked,
            creatorNick: creator.nick
        )
    }
}
