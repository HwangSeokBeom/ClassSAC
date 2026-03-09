//
//  CommentListViewState.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CommentListViewState {
    let courseTitle: String
    let selectedSortTitle: String
    let commentCountText: String
    let commentCellViewModels: [CommentCellViewModel]
    let isEmptyViewHidden: Bool
    let isLoading: Bool

    static let empty = CommentListViewState(
        courseTitle: "",
        selectedSortTitle: CommentSortOption.latest.title,
        commentCountText: "댓글 0개",
        commentCellViewModels: [],
        isEmptyViewHidden: false,
        isLoading: false
    )
}
