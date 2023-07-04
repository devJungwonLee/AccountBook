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
        guard let id,
              let bank = bank?.toDomain(),
              let number,
              let name,
              let date else {
            return nil
        }
        
        return Account(
            id: id,
            bank: bank,
            number: number,
            name: name,
            date: date
        )
    }
    
}
