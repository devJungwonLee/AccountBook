//
//  AccountRepository.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/03.
//

import Foundation
import Combine

final class AccountRepository: AccountRepositoryType {
    private let persistentStorage: PersistentStorage
    
    init(persistentStorage: PersistentStorage = .shared) {
        self.persistentStorage = persistentStorage
    }
    
    func fetchAccountList() -> AnyPublisher<[Account], Error> {
        return Future<[Account], Error> { [unowned self] promise in
            do {
                let accountObjects = try persistentStorage.fetchAll(type: AccountObject.self)
                let accounts = accountObjects.compactMap { $0.toDomain() }
                return promise(.success(accounts))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchAccount(_ id: UUID) -> AnyPublisher<Account, Error> {
        return Future<Account, Error> { [unowned self] promise in
            do {
                let accountObject = try persistentStorage.fetch(attribute: \AccountObject.uuid, value: id)
                guard let account = accountObject.toDomain() else {
                    return promise(.failure(RepositoryError.transform))
                }
                return promise(.success(account))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [unowned self] promise in
            do {
                let accountObject = persistentStorage.create(type: AccountObject.self)
                accountObject.configure(with: account)
                try persistentStorage.save()
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [unowned self] promise in
            do {
                let accountObject = try persistentStorage.fetch(attribute: \AccountObject.uuid, value: account.id)
                accountObject.configure(with: account)
                try persistentStorage.save()
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteAccount(_ account: Account) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [unowned self] promise in
            do {
                let accountObject = try persistentStorage.fetch(attribute: \AccountObject.uuid, value: account.id)
                try persistentStorage.delete(object: accountObject)
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
