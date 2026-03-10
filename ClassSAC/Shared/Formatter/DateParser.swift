//
//  DateParser.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

enum DateParser {

    private static let iso8601WithFractionalSecondsStrategy = Date.ISO8601FormatStyle(
        includingFractionalSeconds: true,
        timeZone: .gmt
    )

    private static let iso8601Strategy = Date.ISO8601FormatStyle(
        timeZone: .gmt
    )

    static func parseISO8601(_ value: String) -> Date? {
        if let date = try? Date(value, strategy: iso8601WithFractionalSecondsStrategy) {
            return date
        }

        if let date = try? Date(value, strategy: iso8601Strategy) {
            return date
        }

        return nil
    }

    static func parseOptionalISO8601(_ value: String?) -> Date? {
        guard let value else { return nil }
        return parseISO8601(value)
    }
}
