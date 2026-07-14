//
//  Data+.swift
//  AccountBook
//
//  Created by 이정원 on 7/14/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import Foundation
import CryptoKit

extension Data {
    var sha256: String {
        SHA256.hash(data: self)
            .map { String(format: "%02x", $0) }
            .joined()
    }
}
