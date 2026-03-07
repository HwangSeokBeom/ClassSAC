//
//  AppFont.swift
//  SeSAC8RecapReference
//
//  Created by Jack on 3/3/26.
//

import UIKit

enum AppFont {
    case title       // 15pt, semibold - 페이지 타이틀 · 버튼 · 가격
    case cardTitle   // 14pt, semibold - Card Title
    case button      // 13pt, semibold - 버튼 텍스트 · 링크
    case body        // 12pt, regular  - 본문 텍스트 · 카드 설명
    case label       // 12pt, semibold - 필드 라벨 · 태그 텍스트
    case chip        // 11pt, medium   - 카테고리 칩 · 정렬 라벨
    case caption     // 10pt, semibold - 탭바 · 뱃지 · 캡션

    var font: UIFont {
        switch self {
        case .title:     return .systemFont(ofSize: 15, weight: .semibold)
        case .cardTitle: return .systemFont(ofSize: 14, weight: .semibold)
        case .button:    return .systemFont(ofSize: 13, weight: .semibold)
        case .body:      return .systemFont(ofSize: 12, weight: .regular)
        case .label:     return .systemFont(ofSize: 12, weight: .semibold)
        case .chip:      return .systemFont(ofSize: 11, weight: .medium)
        case .caption:   return .systemFont(ofSize: 10, weight: .semibold)
        }
    }
}
