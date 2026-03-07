//
//  CourseThumbnailProviding.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import UIKit

protocol CourseThumbnailProviding {
    func loadThumbnail(
        on imageView: UIImageView,
        path: String?
    )

    func cancelLoad(
        on imageView: UIImageView
    )
}
