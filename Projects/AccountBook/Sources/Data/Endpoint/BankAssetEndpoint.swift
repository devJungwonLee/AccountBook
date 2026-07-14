//
//  BankAssetEndpoint.swift
//  AccountBook
//
//  Created by 이정원 on 7/14/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import Foundation

enum BankAssetEndpoint {
    static let manifest = APIEndpoint(
        baseURL: Bundle.assetsURL,
        path: "/bank_assets/manifest.json",
        method: .get
    )
    
    static let assets = APIEndpoint(
        baseURL: Bundle.assetsURL,
        path: "/bank_assets/assets.zip",
        method: .get,
        headers: ["Content-Type": "application/zip"]
    )
}
