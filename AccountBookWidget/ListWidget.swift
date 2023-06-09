//
//  ListWidget.swift
//  AccountBookWidgetExtension
//
//  Created by 이정원 on 2023/06/07.
//

import SwiftUI
import WidgetKit

struct ListWidget: View {
    let accountList: [IntentAccount]?
    let itemCount: Int
    
    var body: some View {
        let presentingList = makePresentingList()
        let count = presentingList.count
        GeometryReader { proxy in
            LazyVStack(spacing: 0) {
                ForEach(0..<count, id: \.self) { index in
                    let account = presentingList[index]
                    if let url = URL(string: account.identifier ?? "") {
                        Link(destination: url) {
                            WidgetItemView(account: account)
                                .frame(height: proxy.size.height / CGFloat(count))
                        }
                    } else {
                        WidgetItemView(account: account)
                            .frame(height: proxy.size.height / CGFloat(count))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func makePresentingList() -> [IntentAccount] {
        if let accountList {
            let placeholder = IntentAccount(identifier: "", display: "")
            if accountList.count >= itemCount { return Array(accountList[0..<itemCount]) }
            return accountList + [IntentAccount](repeating: placeholder, count: itemCount - accountList.count)
        } else {
            let placeholder = IntentAccount(identifier: "", display: "은행 계좌")
            return [IntentAccount](repeating: placeholder, count: itemCount)
        }
    }
}
