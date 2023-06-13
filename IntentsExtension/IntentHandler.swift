//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by 이정원 on 2023/06/07.
//

import Intents
import RealmSwift

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any? {
        return self
    }
}

extension IntentHandler: SelectAccountIntentHandling {
    func provideAccountListOptionsCollection(for intent: SelectAccountIntent, with completion: @escaping (INObjectCollection<IntentAccount>?, Error?) -> Void) {
        let collection = fetchAccountCollection()
        completion(collection, nil)
    }
}

extension IntentHandler: CopyAccountNumberIntentHandling {
    func handle(intent: CopyAccountNumberIntent, completion: @escaping (CopyAccountNumberIntentResponse) -> Void) {
        completion(.init(code: .continueInApp, userActivity: nil))
    }
    
    func resolveAccount(for intent: CopyAccountNumberIntent, with completion: @escaping (IntentAccountResolutionResult) -> Void) {
        guard let account = intent.account else {
            completion(.needsValue())
            return
        }
        completion(.success(with: account))
    }
    
    func provideAccountOptionsCollection(for intent: CopyAccountNumberIntent, with completion: @escaping (INObjectCollection<IntentAccount>?, Error?) -> Void) {
        let collection = fetchAccountCollection()
        completion(collection, nil)
    }
}

extension IntentHandler {
    private func fetchAccountCollection() -> INObjectCollection<IntentAccount>? {
        let persistentStorage: PersistentStorageType = PersistentStorage()
        var accountObjects = [AccountObject]()
        if let results = try? persistentStorage.readAll(type: AccountObject.self) {
            accountObjects = Array(results)
        }
    
        let accounts = accountObjects.map { accountObject in
            let intentAccount = IntentAccount(
                identifier: accountObject.id.uuidString,
                display: accountObject.name,
                subtitle: accountObject.number,
                image: INImage(named: accountObject.bank?.code ?? "placeholder")
            )
            intentAccount.bankCode = accountObject.bank?.code
            return intentAccount
        }.sorted { $0.displayString < $1.displayString }
        return .init(items: accounts)
    }
}
