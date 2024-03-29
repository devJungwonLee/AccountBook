//
//  BackupRecoveryRepository.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/13.
//

import Foundation
import Combine

final class BackupRecoveryRepository: BackupRecoveryRepositoryType {
    private let persistentStorage: PersistentStorage
    
    init(persistentStorage: PersistentStorage = .shared) {
        self.persistentStorage = persistentStorage
    }
    
    func fetchBackupDate() -> AnyPublisher<Date, Error> {
        return Future<Date, Error> { [unowned self] promise in
            do {
                let backupObjects = try persistentStorage.fetchAll(type: BackupObject.self, storeType: .cloud)
                guard let backupDate = backupObjects.first?.backupDate else { throw DatabaseError.notFound }
                return promise(.success(backupDate))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveBackupDate(_ date: Date) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [unowned self] promise in
            do {
                try persistentStorage.deleteAll(type: BackupObject.self, storeType: .cloud)
                let backupObject = persistentStorage.create(type: BackupObject.self, storeType: .cloud)
                backupObject.backupDate = date
                try persistentStorage.save()
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchAccountCount() -> AnyPublisher<Int, Error> {
        return Future<Int, Error> { [unowned self] promise in
            do {
                let accountObjects = try persistentStorage.fetchAll(type: AccountObject.self, storeType: .cloud)
                if accountObjects.isEmpty {  return promise(.failure(DatabaseError.empty)) }
                return promise(.success(accountObjects.count))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteBackupData() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [unowned self] promise in
            do {
                try persistentStorage.deleteAll(type: AccountObject.self, storeType: .cloud)
                try persistentStorage.deleteAll(type: BackupObject.self, storeType: .cloud)
                try persistentStorage.save()
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func uploadAccounts() -> AnyPublisher<Int, Error> {
        return Future<Int, Error> { [unowned self] promise in
            do {
                let accountObjects = try persistentStorage.fetchAll(type: AccountObject.self)
                if accountObjects.isEmpty { return promise(.failure(DatabaseError.empty)) }
                let copy = accountObjects.compactMap { $0.copy() }
                try persistentStorage.upload(with: copy)
                return promise(.success(accountObjects.count))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func downloadAccounts() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [unowned self] promise in
            do {
                let accountObjects = try persistentStorage.fetchAll(type: AccountObject.self, storeType: .cloud)
                if accountObjects.isEmpty { return promise(.failure(DatabaseError.empty)) }
                let copy = accountObjects.compactMap { $0.copy() }
                try persistentStorage.download(with: copy)
                return promise(.success(()))
            } catch(let error) {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
