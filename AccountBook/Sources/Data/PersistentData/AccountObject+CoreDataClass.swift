//
//  AccountObject+CoreDataClass.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/04.
//
//

import Foundation
import CoreData

@objc(AccountObject)
public class AccountObject: NSManagedObject {
    func toDomain() -> Account? {
        guard let uuid,
              let bank = bank?.toDomain(),
              let number,
              let name,
              let date else {
            return nil
        }
        
        return Account(
            id: uuid,
            bank: bank,
            number: number,
            name: name,
            date: date
        )
    }
    
    func configure(with account: Account) {
        guard let context = self.managedObjectContext else { return }
        self.uuid = account.id
        self.date = account.date
        self.name = account.name
        self.number = account.number
        if self.bank == nil {
            self.bank = BankObject(context: context)
        }
        self.bank?.configure(with: account.bank)
    }
    
    func copy() -> AccountObject? {
        guard let context = self.managedObjectContext,
              let account = self.toDomain() else { return nil }
        let accountObject = AccountObject(context: context)
        accountObject.configure(with: account)
        return accountObject
    }
}
