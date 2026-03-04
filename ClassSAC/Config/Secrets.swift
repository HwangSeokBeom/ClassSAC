//
//  Secrets.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/4/26.
//

import Foundation

enum Secrets {

    private static let encodedToken =
        "ZXlKaGJHY2lPaUpJVXpJMU5pSjkuZXlKaGRXUWlPaUl4WkRnMU0yTmhPV1l4T0dZME56SmlaR1V4T1RVMU9EbGhNRE5pWWpBeU1TSXNJbTVpWmlJNk1UY3pOVEF6TmpreU5DNHdNemNzSW5OMVlpSTZJalkzTm1FNFptWmpabVV6TmpRd05qWTBNelkwWVdSbU1TSXNJbk5qYjNCbGN5STZXeUpoY0dsZmNtVmhaQ0pkTENKMlpYSnphVzl1SWpveGZRLkhEa3ZISmc2TW5Mc2pFcEdMbTIwVzRVSUF4ck9PSzRQbzJtdUVvN3RjZUE="

    static var tmdbAccessToken: String {
        guard
            let data = Data(base64Encoded: encodedToken),
            let token = String(data: data, encoding: .utf8)
        else {
            fatalError("Invalid TMDB token encoding")
        }
        return token
    }

    static let tmdbBaseURL =
        "https://api.themoviedb.org/3"
}
