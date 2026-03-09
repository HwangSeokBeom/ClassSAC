//
//  ImageURLBuilder.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation

enum ImageURLBuilder {

    static func makeURL(path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }

        let trimmedBaseURLString = Secrets.BaseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let trimmedPathString = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        return URL(string: "\(trimmedBaseURLString)/\(trimmedPathString)")
    }
}
