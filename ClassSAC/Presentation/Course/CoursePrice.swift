//
//  CoursePrice.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

enum CoursePrice: Equatable {
    case free
    case normal(price: Int)
    case discounted(originalPrice: Int, salePrice: Int)

    init(price: Int?, salePrice: Int?) {
        let originalPrice = price ?? 0
        let discountedPrice = salePrice ?? originalPrice

        if originalPrice == 0 || discountedPrice == 0 {
            self = .free
            return
        }

        if discountedPrice < originalPrice {
            self = .discounted(
                originalPrice: originalPrice,
                salePrice: discountedPrice
            )
            return
        }

        self = .normal(price: originalPrice)
    }
}
