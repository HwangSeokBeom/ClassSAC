//
//  Course+Extension.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

extension Course {
    func updatingLikeState(_ isLiked: Bool) -> Course {
        Course(
            id: id,
            category: category,
            title: title,
            description: description,
            price: price,
            salePrice: salePrice,
            thumbnailURL: thumbnailURL,
            imageURLs: imageURLs,
            createdAt: createdAt,
            isLiked: isLiked,
            creatorNick: creatorNick
        )
    }
    
    var isFreeForSort: Bool {
        if case .free = coursePrice {
            return true
        }
        return false
    }

    var originalPriceForSort: Int {
        switch coursePrice {
        case .free:
            return 0
        case .normal(let price):
            return price
        case .discounted(let originalPrice, _):
            return originalPrice
        }
    }
}
