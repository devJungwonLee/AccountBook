//
//  AccountWidgetView.swift
//  AccountBookWidgetExtension
//
//  Created by 이정원 on 2023/07/08.
//

import SwiftUI

struct AccountWidgetView: View {
    var account: IntentAccount?
        
    var body: some View {
        VStack(spacing: 16) {
            Image(account?.bankCode ?? "placeholder")
                .resizable()
                .frame(width: 60, height: 60)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(30)
            VStack(spacing: 4) {
                Text(account?.displayString ?? "은행 계좌")
                    .lineLimit(2)
                    .font(.system(size: 16, weight: .semibold))
                Text(account?.subtitleString ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
        }
        .widgetURL(URL(string: account?.identifier ?? ""))
    }
}

struct AccountWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        AccountWidgetView()
    }
}
