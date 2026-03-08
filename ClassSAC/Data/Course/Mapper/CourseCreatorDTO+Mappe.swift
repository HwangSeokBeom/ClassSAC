//
//  CourseCreatorDTO+Mapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension CourseCreatorDTO {

    func toEntity() -> CourseDetailCreator {
        CourseDetailCreator(
            userID: userID,
            nick: nick,
            profileImageURL: profileImage
        )
    }
}
