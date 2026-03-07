//
//  CoursePriceFormatter.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

enum CoursePriceFormatter {

    static func formattedPrice(_ price: Int) -> String {
        "\(price.formatted(.number.locale(Locale(identifier: "ko_KR"))))원"
    }

    static func formattedDiscountPercent(
        originalPrice: Int,
        salePrice: Int
    ) -> String {
        guard originalPrice > 0 else { return "0%" }

        let discountRate = (Double(originalPrice - salePrice) / Double(originalPrice)) * 100
        let roundedDiscountRate = Int(discountRate.rounded())

        return "\(roundedDiscountRate)%"
    }
}
