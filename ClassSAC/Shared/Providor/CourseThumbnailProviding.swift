//
//  CourseThumbnailProviding.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import UIKit

protocol RemoteImageProviding {
    func loadThumbnail(
        on imageView: UIImageView,
        path: String?
    )

    func cancelLoad(
        on imageView: UIImageView
    )
}
