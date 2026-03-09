//
//  CourseLikeStatusNotifier.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol CourseLikeStatusBroadcasting {
    func post(courseID: String, isLiked: Bool)
    func observe() -> Observable<CourseLikeStatusChangedPayload>
}

final class CourseLikeStatusNotifier: CourseLikeStatusBroadcasting {

    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    func post(courseID: String, isLiked: Bool) {
        let payload = CourseLikeStatusChangedPayload(
            courseID: courseID,
            isLiked: isLiked
        )

        notificationCenter.post(
            name: .courseLikeStatusDidChange,
            object: payload
        )
    }

    func observe() -> Observable<CourseLikeStatusChangedPayload> {
        notificationCenter.rx.notification(.courseLikeStatusDidChange)
            .compactMap { notification in
                notification.object as? CourseLikeStatusChangedPayload
            }
    }
}
