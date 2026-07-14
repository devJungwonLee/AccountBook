//
//  Bundle+.swift
//  AccountBook
//
//  Created by 이정원 on 7/21/23.
//

import Foundation

extension Bundle {
    static let appVersion: String = {
        main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }()
    
    static let assetsURL: String = {
        main.infoDictionary?["AssetsURL"] as? String ?? ""
    }()
}
