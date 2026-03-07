//
//  CourseListCellViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

struct CourseListCellViewModel {
    let courseID: String
    let thumbnailImageURLString: String?
    let title: String
    let creatorNick: String
    let isLiked: Bool

    let originalPriceText: String?
    let salePriceText: String?
    let discountPercentText: String?

    let shouldShowOriginalPrice: Bool
    let shouldShowSalePrice: Bool
    let shouldShowDiscountPercent: Bool
    let isFree: Bool
}
