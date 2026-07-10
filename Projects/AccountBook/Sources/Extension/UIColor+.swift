//
//  UIColor+.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/03.
//

import UIKit

extension UIColor {
    static let main = UIColor(rgb: 0x74A4F3)
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
