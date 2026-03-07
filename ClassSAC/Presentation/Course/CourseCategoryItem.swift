//
//  CourseCategoryItem.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

enum CourseCategoryItem: Hashable {
    case all
    case category(CourseCategory)

    var title: String {
        switch self {
        case .all:
            return "전체"
        case .category(let courseCategory):
            return courseCategory.title
        }
    }
}
