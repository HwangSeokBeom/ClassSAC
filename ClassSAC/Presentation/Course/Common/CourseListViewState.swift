//
//  CourseListViewState.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

struct CourseListViewState {
    let categories: [CourseCategoryCellViewModel]
    let courses: [CourseListCellViewModel]
    let courseCountText: String
    let selectedSortType: CourseSortType
}
