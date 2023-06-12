//
//  WidgetItemView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import SwiftUI

struct WidgetItemView: View {
    let account: IntentAccount
    
    var body: some View {
        HStack {
            Image(account.bankCode ?? "placeholder")
                .resizable()
                .frame(width: 52, height: 52)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(26)
            VStack(alignment: .leading, spacing: 4) {
                Text(account.displayString)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                Text(account.subtitleString ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
        }
    }
}

struct WidgetItemView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetItemView(account: .init(identifier: "", display: ""))
    }
}
