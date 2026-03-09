//
//  CommentListViewState.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

struct CommentListViewState {
    let courseTitle: String
    let selectedSortOption: CommentSortOption
    let commentCount: Int
    let commentCellViewModels: [CommentCellViewModel]
    let isEmptyViewHidden: Bool
    let isLoading: Bool

    static let empty = CommentListViewState(
        courseTitle: "",
        selectedSortOption: .latest,
        commentCount: 0,
        commentCellViewModels: [],
        isEmptyViewHidden: false,
        isLoading: false
    )
}
