//
//  FetchMyProfileUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift

protocol FetchMyProfileUseCase {
    func execute() -> Single<UserProfile>
}
