//
//  AccountBookWidget.swift
//  AccountBookWidget
//
//  Created by 이정원 on 2023/07/08.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: SelectAccountIntent())
    }
    
    func getSnapshot(for configuration: SelectAccountIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let configuration = SelectAccountIntent()
        if context.isPreview {
            let accounts = [
                IntentAccount(identifier: nil, display: "토스뱅크 계좌"),
                IntentAccount(identifier: nil, display: "카카오뱅크 계좌"),
                IntentAccount(identifier: nil, display: "KB국민은행 계좌"),
                IntentAccount(identifier: nil, display: "SC제일은행 계좌")
            ]
            accounts[0].bankCode = "tossbank"
            accounts[1].bankCode = "kakaobank"
            accounts[2].bankCode = "kb"
            accounts[3].bankCode = "sc"
            configuration.accounts = accounts
        }
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: SelectAccountIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let updatedAccounts = makeUpdatedAccountList(from: configuration.accounts)
        configuration.accounts = updatedAccounts
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func makeUpdatedAccountList(from accountList: [IntentAccount]?) -> [IntentAccount]? {
        guard let accountList else { return nil }
        let uuids = accountList.compactMap { UUID(uuidString: $0.identifier ?? "") }
        let persistentStorage = PersistentStorage.shared
        
        return uuids.compactMap { (uuid: UUID) -> IntentAccount? in
            let accountObject = try? persistentStorage.fetch(attribute: \AccountObject.uuid, value: uuid)
            guard let accountObject else { return nil }
            
            let intentAccount = IntentAccount(
                identifier: accountObject.uuid?.uuidString,
                display: accountObject.name ?? "",
                subtitle: accountObject.number,
                image: INImage(named: accountObject.bank?.code ?? "placeholder")
            )
            intentAccount.bankCode = accountObject.bank?.code
            return intentAccount
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SelectAccountIntent
}

struct AccountBookWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily: WidgetFamily

    var body: some View {
        let accountList = entry.configuration.accounts
        switch widgetFamily {
        case .systemSmall:
            AccountWidgetView(account: accountList?.first)
        case .systemMedium:
            AccountListWidgetView(accountList: accountList, itemCount: 2)
        case .systemLarge:
            AccountListWidgetView(accountList: accountList, itemCount: 4)
        default:
            EmptyView()
        }
    }
}

struct AccountBookWidget: Widget {
    let kind: String = "AccountBookWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectAccountIntent.self, provider: Provider()) { entry in
            AccountBookWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("계좌번호 복사")
        .description("자주 쓰는 계좌를 등록하여\n더 빠르게 계좌번호를 복사해 보세요.")
    }
}

struct AccountBookWidget_Previews: PreviewProvider {
    static var previews: some View {
        AccountBookWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: SelectAccountIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
