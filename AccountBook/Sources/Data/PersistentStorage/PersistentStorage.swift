//
//  PersistentStorage.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import Foundation
import RealmSwift

enum DataBaseError: Error {
    case notFoundError
}

protocol PersistentStorageType {
    func read<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws -> T
    func readAll<T: Object>(type: T.Type) throws -> Results<T>
    func create<T: Object>(object: T) throws
    func delete<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws
}

final class PersistentStorage: PersistentStorageType {
    private var realm: Realm {
        get throws {
            let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GroupIdentifier.value)
            let realmURL = container?.appendingPathComponent("default.realm")
            let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
            return try Realm(configuration: config)
        }
    }
    
    func readAll<T: Object>(type: T.Type) throws -> Results<T>  {
        let realm = try realm
        let objects = realm.objects(T.self)
        return objects
    }
    
    func read<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws -> T {
        let realm = try realm
        guard let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey) else {
            throw DataBaseError.notFoundError
        }
        return object
    }
    
    func create<T: Object>(object: T) throws {
        let realm = try realm
        try realm.write {
            realm.add(object)
        }
    }
    
    func delete<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws {
        let object = try read(type: T.self, primaryKey: primaryKey)
        let realm = try realm
        try realm.write {
            realm.delete(object)
        }
    }
}
