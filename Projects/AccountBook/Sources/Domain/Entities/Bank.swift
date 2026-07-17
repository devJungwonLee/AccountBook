//
//  Bank.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/08.
//

import Foundation

struct Bank: Decodable, Hashable {
    let code: String
    let name: String
    let logoURL: URL?
    
    init(code: String, name: String, logoURL: URL? = nil) {
        self.code = code
        self.name = name
        self.logoURL = logoURL
    }
}
