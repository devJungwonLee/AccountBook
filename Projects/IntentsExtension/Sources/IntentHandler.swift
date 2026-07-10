//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by 이정원 on 2023/07/08.
//

import Intents

class IntentHandler: INExtension, SelectAccountIntentHandling {
    func provideAccountsOptionsCollection(for intent: SelectAccountIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<IntentAccount>?, Error?) -> Void) {
        let persistentStorage = PersistentStorage.shared
        guard let accountObjects = try? persistentStorage.fetchAll(type: AccountObject.self) else {
            return
        }
        
        let accounts = accountObjects.map { accountObject in
            let intentAccount = IntentAccount(
                identifier: accountObject.uuid?.uuidString,
                display: accountObject.name ?? "",
                subtitle: accountObject.number,
                image: INImage(named: accountObject.bank?.code ?? "placeholder")
            )
            intentAccount.bankCode = accountObject.bank?.code
            return intentAccount
        }
        completion(.init(items: accounts), nil)
    }
}
