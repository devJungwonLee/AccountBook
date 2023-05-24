//
//  AccountObject.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import Foundation
import RealmSwift

final class AccountObject: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var bank: BankObject?
    @Persisted var number: String
    @Persisted var name: String
    @Persisted var date: Date
    
    convenience init(account: Account) {
        self.init()
        self.id = account.id
        self.bank = .init(bank: account.bank)
        self.number = account.number
        self.name = account.name
        self.date = account.date
    }
    
    func toDomain() -> Account {
        return Account(
            id: id,
            bank: bank?.toDomain() ?? .init(code: "", name: ""),
            number: number,
            name: name,
            date: date
        )
    }
}
