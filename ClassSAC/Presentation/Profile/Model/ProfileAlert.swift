//
//  ProfileAlert.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation

enum ProfileAlert {
    case logoutConfirm

    var title: String {
        switch self {
        case .logoutConfirm:
            return "로그아웃"
        }
    }

    var message: String {
        switch self {
        case .logoutConfirm:
            return "로그아웃 하시겠습니까?"
        }
    }

    var confirmTitle: String {
        switch self {
        case .logoutConfirm:
            return "확인"
        }
    }

    var cancelTitle: String {
        switch self {
        case .logoutConfirm:
            return "취소"
        }
    }
}
