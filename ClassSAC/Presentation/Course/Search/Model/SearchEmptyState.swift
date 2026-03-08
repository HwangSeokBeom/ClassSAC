//
//  SearchEmptyState.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

enum SearchEmptyState {
    case none
    case initial
    case noResult
}

extension SearchEmptyState {
    
    var message: String? {
        switch self {
        case .none:
            return nil
        case .initial:
            return "검색어를 입력해 클래스를 검색해보세요."
        case .noResult:
            return "검색 결과가 없습니다."
        }
    }
}
