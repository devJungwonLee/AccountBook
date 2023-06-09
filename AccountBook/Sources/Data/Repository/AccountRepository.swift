//
//  AccountRepository.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import Foundation
import Combine
import RealmSwift

final class AccountRepository: AccountRepositoryType {
    private let persistentStorage: PersistentStorageType
    
    init(persistentStorage: PersistentStorageType) {
        self.persistentStorage = persistentStorage
    }
    
    func fetchAccountList() -> AnyPublisher<[Account], Error> {
        return Future<[Account], Error> { [unowned self] promise in
            do {
                let accountObjects = try self.persistentStorage.readAll(type: AccountObject.self)
                let accounts = Array(accountObjects).map { $0.toDomain() }
                return promise(.success(accounts))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchAccount(_ id: UUID) -> AnyPublisher<Account, Error> {
        return Future<Account, Error> { [unowned self] promise in
            do {
                let accountObject = try self.persistentStorage.read(type: AccountObject.self, primaryKey: id)
                let account = accountObject.toDomain()
                return promise(.success(account))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            do {
                let accountObject = AccountObject(account: account)
                try self?.persistentStorage.create(object: accountObject)
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            do {
                let accountObject = AccountObject(account: account)
                try self?.persistentStorage.delete(type: AccountObject.self, primaryKey: account.id)
                try self?.persistentStorage.create(object: accountObject)
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            do {
                try self?.persistentStorage.delete(type: AccountObject.self, primaryKey: account.id)
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
