//
//  AccountRepositoryType.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import Combine

protocol AccountRepositoryType {
    func fetchAccountList() -> AnyPublisher<[Account], Error>
    func saveAccount(_ account: Account) -> AnyPublisher<Void, Error>
    func updateAccount(_ account: Account) -> AnyPublisher<Void, Error>
    func deleteAccount(_ account: Account) -> AnyPublisher<Void, Error>
}
