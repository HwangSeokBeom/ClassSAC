//
//  UserDefaultsCurrentUserStore.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

final class UserDefaultsCurrentUserStore: CurrentUserStoring {

    private enum Key {
        static let currentUserID = "ClassSAC.currentUserID"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var currentUserID: String? {
        userDefaults.string(forKey: Key.currentUserID)
    }

    func saveCurrentUserID(_ userID: String) {
        userDefaults.set(userID, forKey: Key.currentUserID)
    }

    func clearCurrentUserID() {
        userDefaults.removeObject(forKey: Key.currentUserID)
    }
}
