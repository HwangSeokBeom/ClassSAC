//
//  ClassSACQuery.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

protocol ClassSACQuery {
    var queryItems: [URLQueryItem] { get }
}

struct SearchCoursesQuery: ClassSACQuery {
    let title: String

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "title", value: title)
        ]
    }
}

struct CoursesQuery: ClassSACQuery {
    let category: String?
    let sort: String?

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []

        if let category, !category.isEmpty {
            items.append(URLQueryItem(name: "category", value: category))
        }

        if let sort, !sort.isEmpty {
            items.append(URLQueryItem(name: "sort", value: sort))
        }

        return items
    }
}
