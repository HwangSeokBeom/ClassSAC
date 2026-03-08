//
//  CourseDetailViewState.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CourseDetailViewState {
    let imageURLs: [String]
    let title: String
    let descriptionText: String
    let creatorNick: String
    let isLiked: Bool

    let locationText: String
    let durationText: String
    let capacityText: String

    let originalPriceText: String?
    let salePriceText: String?
    let discountPercentText: String?

    let shouldShowOriginalPrice: Bool
    let shouldShowSalePrice: Bool
    let shouldShowDiscountPercent: Bool
    let isFree: Bool

    let commentCountText: String
    let commentPreviewCellViewModels: [CourseCommentPreviewCellViewModel]
    let isMoreCommentsButtonEnabled: Bool

    let isLoading: Bool
}
