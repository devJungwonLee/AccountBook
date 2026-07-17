//
//  Bank+.swift
//  AccountBook
//
//  Created by 이정원 on 7/17/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import UIKit

extension Bank {
    var image: UIImage? {
        guard let logoURL else { return .placeholder }
        return UIImage.init(contentsOfFile: logoURL.path) ?? .placeholder
    }
}

extension BankCellState {
    var image: UIImage? {
        guard let logoURL else { return .placeholder }
        return UIImage.init(contentsOfFile: logoURL.path) ?? .placeholder
    }
}

private extension UIImage {
    static let placeholder = UIImage(named: "placeholder")
}
