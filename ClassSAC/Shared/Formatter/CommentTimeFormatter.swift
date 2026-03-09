//
//  CommentTimeFormatter.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

enum CommentTimeFormatter {

    static func string(from date: Date?, now: Date = Date()) -> String {
        guard let date else {
            return "방금 전"
        }

        let secondsDifference = Int(now.timeIntervalSince(date))

        if secondsDifference < 60 {
            return "0분 전"
        }

        if secondsDifference < 3600 {
            let minutes = secondsDifference / 60
            return "\(minutes)분 전"
        }

        if secondsDifference < 86400 {
            let hours = secondsDifference / 3600
            return "\(hours)시간 전"
        }

        if secondsDifference < 604800 {
            let days = secondsDifference / 86400
            return "\(days)일 전"
        }

        return date.formatted(
            .dateTime
                .year()
                .month()
                .day()
                .hour(.defaultDigits(amPM: .abbreviated))
                .minute()
                .locale(Locale(identifier: "ko_KR"))
        )
    }
}
