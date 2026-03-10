//
//  CourseDetailImageCollectionViewCell.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CourseDetailImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "CourseDetailImageCollectionViewCell"

    private let courseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.bgMuted
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        courseImageView.image = nil
    }

    func configure(
        imagePath: String?,
        thumbnailProvider: RemoteImageProviding
    ) {
        thumbnailProvider.loadThumbnail(
            on: courseImageView,
            path: imagePath
        )
    }
}

private extension CourseDetailImageCollectionViewCell {

    func configureHierarchy() {
        [
            courseImageView
        ].forEach { contentView.addSubview($0) }
    }

    func configureLayout() {
        courseImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
