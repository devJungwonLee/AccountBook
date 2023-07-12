//
//  AccountRepositoryType.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import Foundation
import Combine

enum RepositoryError: Error {
    case transform
}

protocol AccountRepositoryType {
    func fetchAccountList() -> AnyPublisher<[Account], Error>
    func fetchAccount(_ id: UUID) -> AnyPublisher<Account, Error>
    func saveAccount(_ account: Account) -> AnyPublisher<Void, Error>
    func updateAccount(_ account: Account) -> AnyPublisher<Void, Error>
    func deleteAccount(_ account: Account) -> AnyPublisher<Void, Error>
    func uploadAccounts() -> AnyPublisher<Int, Error>
    func downloadAccounts() -> AnyPublisher<Void, Error>
}
