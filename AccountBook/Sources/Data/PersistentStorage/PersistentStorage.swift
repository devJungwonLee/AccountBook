//
//  PersistentStorage.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/22.
//

import RealmSwift

enum DataBaseError: Error {
    case notFoundError
}

protocol PersistentStorageType {
    func readAll<T: Object>(type: T.Type) throws -> Results<T>
    func create<T: Object>(object: T) throws
    func delete<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws
}

final class PersistentStorage: PersistentStorageType {
    func readAll<T: Object>(type: T.Type) throws -> Results<T>  {
        let realm = try Realm()
        let objects = realm.objects(T.self)
        return objects
    }
    
    private func read<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws -> T {
        let realm = try Realm()
        guard let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey) else {
            throw DataBaseError.notFoundError
        }
        return object
    }
    
    func create<T: Object>(object: T) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(object)
        }
    }
    
    func delete<T: Object, KeyType>(type: T.Type, primaryKey: KeyType) throws {
        let object = try read(type: T.self, primaryKey: primaryKey)
        let realm = try Realm()
        try realm.write {
            realm.delete(object)
        }
    }
}
