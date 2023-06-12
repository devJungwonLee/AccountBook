//
//  AccountBookWidget.swift
//  AccountBookWidget
//
//  Created by 이정원 on 2023/06/07.
//

import WidgetKit
import SwiftUI
import Intents
import RealmSwift

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: SelectAccountIntent())
    }

    func getSnapshot(for configuration: SelectAccountIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let configuration = SelectAccountIntent()
        if context.isPreview {
            let accountList = [
                IntentAccount(identifier: nil, display: "토스뱅크 계좌"),
                IntentAccount(identifier: nil, display: "카카오뱅크 계좌"),
                IntentAccount(identifier: nil, display: "KB국민은행 계좌"),
                IntentAccount(identifier: nil, display: "SC제일은행 계좌")
            ]
            accountList[0].bankCode = "tossbank"
            accountList[1].bankCode = "kakaobank"
            accountList[2].bankCode = "kb"
            accountList[3].bankCode = "sc"
            configuration.accountList = accountList
        }
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: SelectAccountIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let updatedAccountList = makeUpdatedAccountList(from: configuration.accountList)
        configuration.accountList = updatedAccountList
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
        let persistentStorage: PersistentStorageType = PersistentStorage()
        
        return uuids.compactMap { (uuid: UUID) -> IntentAccount? in
            let accountObject = try? persistentStorage.read(type: AccountObject.self, primaryKey: uuid)
            guard let accountObject else { return nil }
            
            let intentAccount = IntentAccount(
                identifier: accountObject.id.uuidString,
                display: accountObject.name,
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
        let accountList = entry.configuration.accountList
        switch widgetFamily {
        case .systemSmall:
            SmallWidget(account: accountList?.first)
        case .systemMedium:
            ListWidget(accountList: accountList, itemCount: 2)
        case .systemLarge:
            ListWidget(accountList: accountList, itemCount: 4)
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
        .configurationDisplayName("바로 복사")
        .description("대표계좌를 설정하여 더 빠르게\n계좌번호를 복사해 보세요.")
    }
}

struct AccountBookWidget_Previews: PreviewProvider {
    static var previews: some View {
        AccountBookWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: SelectAccountIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
