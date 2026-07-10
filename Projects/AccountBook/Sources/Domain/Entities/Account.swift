//
//  Account.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/20.
//

import Foundation

struct Account {
    let id: UUID
    let bank: Bank
    let number: String
    let name: String
    let date: Date
    
    init(id: UUID = .init(), bank: Bank, number: String, name: String, date: Date = .init()) {
        self.id = id
        self.bank = bank
        self.number = number
        self.name = name
        self.date = date
    }
}
