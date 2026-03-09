//
//  CommentListRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CommentListRootView: BaseRootView {

    let navigationContainerView = UIView()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.textPrimary
        button.backgroundColor = AppColor.bgSurface
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(AppIcon.chervronLeft.image, for: .normal)
        return button
    }()

    let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let summaryContainerView = UIView()

    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    let countSuffixLabel: UILabel = {
        let label = UILabel()
        label.text = "개의 리뷰"
        label.font = AppFont.body.font
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    let sortButton = SortChipButton()

    let commentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 20, right: 0)
        return tableView
    }()

    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 댓글이 없습니다."
        label.font = AppFont.body.font
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    let bottomButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.bgPrimary
        return view
    }()

    let writeCommentButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "댓글 작성"
        configuration.image = UIImage(systemName: "square.and.pencil")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 6
        configuration.baseBackgroundColor = AppColor.accentPrimary
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    override func configureHierarchy() {
        [
            navigationContainerView,
            summaryContainerView,
            commentTableView,
            emptyStateLabel,
            bottomButtonContainerView,
            loadingIndicatorView
        ].forEach { addSubview($0) }

        [
            backButton,
            navigationTitleLabel
        ].forEach { navigationContainerView.addSubview($0) }

        [
            commentCountLabel,
            countSuffixLabel,
            sortButton
        ].forEach { summaryContainerView.addSubview($0) }

        [
            writeCommentButton
        ].forEach { bottomButtonContainerView.addSubview($0) }
    }

    override func configureLayout() {
        navigationContainerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        navigationTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(60)
        }

        summaryContainerView.snp.makeConstraints { make in
            make.top.equalTo(navigationContainerView.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(32)
        }

        commentCountLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        countSuffixLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentCountLabel.snp.trailing).offset(4)
            make.centerY.equalTo(commentCountLabel)
        }

        sortButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.height.equalTo(32)
        }

        bottomButtonContainerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
        }

        writeCommentButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(48)
        }

        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(summaryContainerView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomButtonContainerView.snp.top)
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalTo(commentTableView)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(commentTableView)
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary
        sortButton.configure(title: CommentSortOption.latest.title)
        
        commentTableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier
        )
    }

    func updateNavigationTitle(_ title: String) {
        navigationTitleLabel.text = title
    }

    func updateCommentCount(_ count: Int) {
        commentCountLabel.text = "\(count)"
    }

    func updateSortButtonTitle(_ title: String) {
        sortButton.configure(title: title)
    }
}
