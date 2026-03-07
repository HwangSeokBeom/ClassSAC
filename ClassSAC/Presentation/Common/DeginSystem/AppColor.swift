//
//  AppColor.swift
//  SeSAC8RecapReference
//
//  Created by Jack on 3/3/26.
//

import UIKit

enum AppColor {
    
    static let bgPrimary = UIColor(hex: "#FCFBF9")
    static let bgSurface = UIColor(hex: "#FFFFFF")
    static let bgMuted = UIColor(hex: "#F5F4F2")

    static let accentPrimary = UIColor(hex: "#E85A4F")
    static let tagOrange = UIColor(hex: "#E8913A")
    static let tagOrangeBg = UIColor(hex: "#FFF3E0")

    static let textPrimary = UIColor(hex: "#1E2432")
    static let textSecondary = UIColor(hex: "#8A8A8A")
    static let textTertiary = UIColor(hex: "#ABABAB")

    static let borderSubtle = UIColor(hex: "#EFEFEF")
    static let dimOverlay = UIColor(hex: "#000000", alpha: 0.4)
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: alpha
        )
    }
}
