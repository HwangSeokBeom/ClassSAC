//
//  CourseListCellViewModelMapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

enum CourseListCellViewModelMapper {

    static func map(course: Course) -> CourseListCellViewModel {
        switch course.coursePrice {
        case .free:
            return CourseListCellViewModel(
                courseID: course.id,
                thumbnailImageURLString: course.thumbnailURL,
                categoryTitle: course.category.title,
                title: course.title,
                descriptionText: course.description,
                creatorNick: course.creatorNick,
                isLiked: course.isLiked,
                originalPriceText: nil,
                salePriceText: nil,
                discountPercentText: nil,
                shouldShowOriginalPrice: false,
                shouldShowSalePrice: false,
                shouldShowDiscountPercent: false,
                isFree: true
            )

        case .normal(let price):
            return CourseListCellViewModel(
                courseID: course.id,
                thumbnailImageURLString: course.thumbnailURL,
                categoryTitle: course.category.title,
                title: course.title,
                descriptionText: course.description,
                creatorNick: course.creatorNick,
                isLiked: course.isLiked,
                originalPriceText: nil,
                salePriceText: CoursePriceFormatter.formattedPrice(price),
                discountPercentText: nil,
                shouldShowOriginalPrice: false,
                shouldShowSalePrice: true,
                shouldShowDiscountPercent: false,
                isFree: false
            )

        case .discounted(let originalPrice, let salePrice):
            return CourseListCellViewModel(
                courseID: course.id,
                thumbnailImageURLString: course.thumbnailURL,
                categoryTitle: course.category.title,
                title: course.title,
                descriptionText: course.description,
                creatorNick: course.creatorNick,
                isLiked: course.isLiked,
                originalPriceText: CoursePriceFormatter.formattedPrice(originalPrice),
                salePriceText: CoursePriceFormatter.formattedPrice(salePrice),
                discountPercentText: CoursePriceFormatter.formattedDiscountPercent(
                    originalPrice: originalPrice,
                    salePrice: salePrice
                ),
                shouldShowOriginalPrice: true,
                shouldShowSalePrice: true,
                shouldShowDiscountPercent: true,
                isFree: false
            )
        }
    }
}
