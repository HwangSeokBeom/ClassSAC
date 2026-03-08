//
//  Date+CourseCommentDisplay.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension Date {

    var courseCommentDisplayText: String {
        let now = Date()
        let interval = Int(now.timeIntervalSince(self))

        if interval < 60 {
            return "방금 전"
        }

        let minute = interval / 60
        if minute < 60 {
            return "\(minute)분 전"
        }

        let hour = minute / 60
        if hour < 24 {
            return "\(hour)시간 전"
        }

        let day = hour / 24
        return "\(day)일 전"
    }
}
