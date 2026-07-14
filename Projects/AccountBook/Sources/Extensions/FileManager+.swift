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
            return try url(
                for: directory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        }
    }

    private var directory: SearchPathDirectory {
        #if DEBUG
        .documentDirectory
        #else
        .applicationSupportDirectory
        #endif
    }
}
