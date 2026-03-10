//
//  AccessTokenStoring.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

protocol AccessTokenStoring: AnyObject {
    var accessToken: String? { get }
    func save(accessToken: String)
    func clear()
}
