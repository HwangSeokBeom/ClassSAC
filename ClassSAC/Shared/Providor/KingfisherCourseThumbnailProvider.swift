//
//  DefaultCourseThumbnailProvider.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import UIKit
import Kingfisher

final class KingfisherCourseThumbnailProvider: RemoteImageProviding {

    private let accessTokenStore: AccessTokenStoring

    init(accessTokenStore: AccessTokenStoring) {
        self.accessTokenStore = accessTokenStore
    }

    func loadThumbnail(
        on imageView: UIImageView,
        path: String?
    ) {
        guard let imageURL = ImageURLBuilder.makeURL(path: path) else {
            imageView.image = nil
            return
        }

        let sesacKey = Secrets.sesacKey
        let accessToken = accessTokenStore.accessToken

        let requestModifier = AnyModifier { request in
            var updatedRequest = request
            updatedRequest.setValue(sesacKey, forHTTPHeaderField: ClassSACHeaderKey.sesacKey)

            if let accessToken, !accessToken.isEmpty {
                updatedRequest.setValue(accessToken, forHTTPHeaderField: ClassSACHeaderKey.authorization)
            }

            return updatedRequest
        }

        imageView.kf.setImage(
            with: imageURL,
            options: [
                .requestModifier(requestModifier),
                .cacheOriginalImage
            ]
        )
    }

    func cancelLoad(
        on imageView: UIImageView
    ) {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
