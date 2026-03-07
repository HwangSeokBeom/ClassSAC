//
//  AuthSessionManager.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation

final class AuthSessionManager {

    static let shared = AuthSessionManager()

    private init() {}

    private var onSessionExpired: (() -> Void)?

    func setSessionExpiredHandler(_ handler: @escaping () -> Void) {
        onSessionExpired = handler
    }

    func expireSession() {
        onSessionExpired?()
    }
}
