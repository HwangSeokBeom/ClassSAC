//
//  CommentSortOption.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CommentSortOption {
    case latest
    case oldest

    var title: String {
        switch self {
        case .latest:
            return "최신순"
        case .oldest:
            return "과거순"
        }
    }
}
