//
//  MediumWidget.swift
//  AccountBookWidgetExtension
//
//  Created by 이정원 on 2023/06/07.
//

import SwiftUI
import WidgetKit

struct MediumWidget: View {
    var accountList: [IntentAccount]?
    
    var body: some View {
        let presentingList = makePresentingList()
        GeometryReader { proxy in
            LazyVStack(spacing: 0) {
                ForEach(0..<presentingList.count, id: \.self) { index in
                    let account = presentingList[index]
                    HStack {
                        Image(account.bankCode ?? "placeholder")
                            .resizable()
                            .frame(width: 52, height: 52)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(26)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(account.displayString)
                                .font(.system(size: 16, weight: .semibold))
                            Text(account.subtitleString ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    }
                    .frame(height: proxy.size.height / 2)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func makePresentingList() -> [IntentAccount] {
        if let accountList {
            let placeholder = IntentAccount(identifier: "", display: "")
            if accountList.count >= 2 { return accountList }
            return accountList + [IntentAccount](repeating: placeholder, count: 2 - accountList.count)
        } else {
            let placeholder = IntentAccount(identifier: "", display: "은행 계좌")
            return [IntentAccount](repeating: placeholder, count: 2)
        }
    }
}

struct MediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidget()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

