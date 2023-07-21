//
//  Bundle+.swift
//  AccountBook
//
//  Created by 이정원 on 7/21/23.
//

import Foundation

extension Bundle {
    static var appVersion: String {
        return (main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
}
