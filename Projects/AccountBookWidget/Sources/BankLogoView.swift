//
//  BankLogoView.swift
//  AccountBookWidgetExtension
//
//  Created by 이정원 on 7/17/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import SwiftUI
import Intents

struct BankLogoView: View {
    private let account: IntentAccount?
    
    init(account: IntentAccount?) {
        self.account = account
    }
    
    var body: some View {
        logoImage
            .resizable()
    }
}

private extension BankLogoView {
    var logoImage: Image {
        guard let bankCode = account?.bankCode,
              let url = FileManager.default.logoURL(bankCode),
              let uiImage = UIImage(contentsOfFile: url.path) else {
            return Image("placeholder")
        }
        return Image(uiImage: uiImage)
    }
}
