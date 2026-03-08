//
//  CourseCategoryCellViewModelMapper.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

enum CourseCategoryCellViewModelMapper {
    static func map(
        categoryItems: [CourseCategoryItem],
        selectedCategoryItems: Set<CourseCategoryItem>
    ) -> [CourseCategoryCellViewModel] {
        categoryItems.map { categoryItem in
            CourseCategoryCellViewModel(
                item: categoryItem,
                title: categoryItem.title,
                isSelected: selectedCategoryItems.contains(categoryItem)
            )
        }
    }
}
