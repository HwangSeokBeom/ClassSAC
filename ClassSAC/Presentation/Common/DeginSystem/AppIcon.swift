//
//  AppIcon.swift
//  SeSAC8RecapReference
//
//  Created by Jack on 3/3/26.
//

import UIKit

enum AppIcon: String {
    case envelope = "envelope"
    case lock = "lock"
    case eye = "eye"
    case eyeSlash = "eye.slash"
    case person = "person"
    case bell = "bell"
    case sort = "arrow.up.arrow.down"
    case heart = "heart"
    case heartFill = "heart.fill"
    case book = "book"
    case search = "magnifyingglass"
    case bookmark = "bookmark"
    case clock = "clock"
    case mapPin = "mappin.and.ellipse"
    case person2 = "person.2"
    case pencilLine = "pencil.line"
    case arrowForward = "arrow.forward"
    case pencil = "pencil"
    case trash = "trash"
    case logout = "iphone.and.arrow.right.outward"
    case chevronDown = "chevron.down"
    case chervronLeft = "chevron.left"
    case chervronRight = "chevron.right"
    case squareAndPencil = "square.and.pencil"

    var image: UIImage? {
        UIImage(systemName: rawValue)
    }
}
