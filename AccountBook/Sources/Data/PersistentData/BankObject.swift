//
//  BankObject.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import RealmSwift

final class BankObject: Object {
    @Persisted var code: String
    @Persisted var name: String
    
    convenience init(bank: Bank) {
        self.init()
        self.code = bank.code
        self.name = bank.name
    }
    
    func toDomain() -> Bank {
        return Bank(code: code, name: name)
    }
}
