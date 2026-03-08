//
//  CourseDetail+Extension.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension CourseDetail {

    func updatingLikeState(_ isLiked: Bool) -> CourseDetail {
        CourseDetail(
            id: id,
            category: category,
            title: title,
            description: description,
            price: price,
            salePrice: salePrice,
            location: location,
            date: date,
            capacity: capacity,
            imageURLs: imageURLs,
            createdAt: createdAt,
            isLiked: isLiked,
            creator: creator
        )
    }
}
