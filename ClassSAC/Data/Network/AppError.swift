//
//  AppError.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

protocol AppError: Error {
    var userMessage: String { get }
    var debugMessage: String { get }
}
