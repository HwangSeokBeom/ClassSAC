//
//  Array+CommentSort.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation

extension Array where Element == Comment {

    func sorted(by sortOption: CommentSortOption) -> [Comment] {
        switch sortOption {
        case .latest:
            return self.sorted { leftComment, rightComment in
                (leftComment.createdAt ?? .distantPast) > (rightComment.createdAt ?? .distantPast)
            }

        case .oldest:
            return self.sorted { leftComment, rightComment in
                (leftComment.createdAt ?? .distantFuture) < (rightComment.createdAt ?? .distantFuture)
            }
        }
    }
}
