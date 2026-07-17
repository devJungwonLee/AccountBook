//
//  FileManager+.swift
//  AccountBook
//
//  Created by 이정원 on 7/13/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import Foundation

extension FileManager {
    var assetStorageURL: URL {
        get throws {
            let identifier = GroupIdentifier.value
            let url = containerURL(forSecurityApplicationGroupIdentifier: identifier)
            guard let url else { fatalError() }
            return url
        }
    }
}

extension FileManager {
    func logoURL(_ code: String) -> URL? {
        try? assetStorageURL
            .appending(component: "bank_assets")
            .appending(component: "logos")
            .appending(component: "\(code).png")
    }
}
