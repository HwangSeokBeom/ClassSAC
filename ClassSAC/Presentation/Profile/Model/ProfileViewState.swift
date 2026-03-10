//
//  ProfileViewState.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

struct ProfileViewState {
    let nick: String
    let email: String
    let profileImagePath: String?
    let isLoading: Bool

    static let empty = ProfileViewState(
        nick: "",
        email: "",
        profileImagePath: nil,
        isLoading: false
    )
}
