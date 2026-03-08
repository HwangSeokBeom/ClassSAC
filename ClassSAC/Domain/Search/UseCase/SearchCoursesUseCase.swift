//
//  SearchCoursesUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import RxSwift

protocol SearchCoursesUseCase {
    func execute(query: String) -> Single<[Course]>
}
