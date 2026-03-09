//
//  CommentCellViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CommentCellViewModel {
    let commentID: String
    let writerNickname: String
    let writerProfileImagePath: String?
    let contentText: String
    let createdAtText: String
    let isMine: Bool
}
