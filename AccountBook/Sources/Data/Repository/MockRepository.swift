//
//  MockRepository.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/03.
//

import Foundation
import Combine

final class MockRepository: AccountRepositoryType {
    func fetchAccountList() -> AnyPublisher<[Account], Error> {
        return Just<[Account]>([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchAccount(_ id: UUID) -> AnyPublisher<Account, Error> {
        let account = Account(bank: .init(code: "", name: ""), number: "", name: "")
        return Just<Account>(account).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func saveAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Just<Void>((())).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func updateAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Just<Void>((())).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Just<Void>((())).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
