//
//  CourseCategory.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

enum CourseCategory: Int, CaseIterable {
    case development = 101
    case life = 102
    case foreignLanguage = 201
    case design = 202
    case beauty = 203
    case finance = 301
    case etc = 900

    var title: String {
        switch self {
        case .development:
            return "개발"
        case .life:
            return "라이프"
        case .foreignLanguage:
            return "외국어"
        case .design:
            return "디자인"
        case .beauty:
            return "뷰티"
        case .finance:
            return "제테크"
        case .etc:
            return "기타"
        }
    }
}
