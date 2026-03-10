//
//  CurrentUserStoring.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

protocol CurrentUserProviding {
    var currentUserID: String? { get }
}

protocol CurrentUserStoring: CurrentUserProviding {
    func saveCurrentUserID(_ userID: String)
    func clearCurrentUserID()
}
