//
//  UserDefaultsAccessTokenStore.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class UserDefaultsAccessTokenStore: AccessTokenStoring {

    private let userDefaults: UserDefaults
    private let accessTokenKey = "ClassSAC.accessToken"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var accessToken: String? {
        userDefaults.string(forKey: accessTokenKey)
    }

    func save(accessToken: String) {
        userDefaults.set(accessToken, forKey: accessTokenKey)
    }

    func clear() {
        userDefaults.removeObject(forKey: accessTokenKey)
    }
}
