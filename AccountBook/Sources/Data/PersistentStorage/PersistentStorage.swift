//
//  PersistentStorage.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/04.
//

import CoreData
import Then

enum DatabaseError: Error {
    case notFound
}

final class PersistentStorage {
    static let shared = PersistentStorage()
    
    private lazy var persistentContainer = NSPersistentContainer(name: "Model").then {
        $0.loadPersistentStores { _, error in
            if let error { print(error) }
        }
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    private func saveContext() throws {
        guard context.hasChanges else {
            return
        }
        try context.save()
    }
    
    func fetchAll<T: NSFetchRequestResult>(type: T.Type) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        return try context.fetch(request)
    }
    
    func fetch<T: NSFetchRequestResult & NSManagedObject, U>(attribute: KeyPath<T, U>, value: U) throws -> T {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        let stringValue = NSExpression(forKeyPath: attribute).keyPath
        request.predicate = NSPredicate(format: "\(stringValue) == %@", argumentArray: [value])
        guard let result = try context.fetch(request).first else {
            throw DatabaseError.notFound
        }
        return result
    }
    
    func create<T: NSManagedObject>(type: T.Type) -> T {
        return T(context: context)
    }
    
    func save() throws {
        try saveContext()
    }
    
    func delete(object: NSManagedObject) throws {
        context.delete(object)
        try saveContext()
    }
}
