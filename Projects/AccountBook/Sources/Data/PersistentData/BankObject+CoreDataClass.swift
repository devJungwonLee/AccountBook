//
//  BankObject+CoreDataClass.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/04.
//
//

import Foundation
import CoreData

@objc(BankObject)
public class BankObject: NSManagedObject {
    func toDomain() -> Bank? {
        guard let code, let name else { return nil }
        let logoURL = FileManager.default.logoURL(code)
        return Bank(code: code, name: name, logoURL: logoURL)
    }
    
    func configure(with bank: Bank) {
        self.code = bank.code
        self.name = bank.name
    }
}
