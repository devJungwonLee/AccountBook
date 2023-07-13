//
//  PersistentStorage.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/04.
//

import CoreData

enum DatabaseError: Error {
    case notFound
}

final class PersistentStorage {
    enum StoreType {
        case local, cloud
    }
    
    static let shared = PersistentStorage()
    
    private var storeURL: URL {
        guard let storeURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.AccountBook"
        ) else {
            fatalError("storeURL Error")
        }
        return storeURL
    }
    
    private var localURL: URL {
        return storeURL.appendingPathComponent("Local.sqlite")
    }
    
    private var cloudURL: URL {
        return storeURL.appendingPathComponent("Cloud.sqlite")
    }
    
    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let localStoreDescription = NSPersistentStoreDescription(url: localURL)
        localStoreDescription.configuration = "Default"
        
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudURL)
        cloudStoreDescription.configuration = "Cloud"
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.jungwon.AccountBook")
        
        let container = NSPersistentCloudKitContainer(name: "Model")
        container.persistentStoreDescriptions = [
            cloudStoreDescription,
            localStoreDescription
        ]
        
        container.loadPersistentStores { _, error in
            if let error { print(error) }
        }
        return container
    }()
    
    private lazy var localPersistentStore: NSPersistentStore = {
        guard let persistentStore = persistentContainer.persistentStoreCoordinator.persistentStore(for: localURL) else {
            fatalError("local persistentStore Error")
        }
        return persistentStore
    }()
    
    private lazy var cloudPersistentStore: NSPersistentStore = {
        guard let persistentStore = persistentContainer.persistentStoreCoordinator.persistentStore(for: cloudURL) else {
            fatalError("cloud persistentStore Error")
        }
        return persistentStore
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
    
    func fetchAll<T: NSFetchRequestResult>(type: T.Type, storeType: StoreType = .local) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        let store = storeType == .local ? localPersistentStore : cloudPersistentStore
        request.affectedStores = [store]
        return try context.fetch(request)
    }
    
    func fetch<T: NSFetchRequestResult & NSManagedObject, U>(attribute: KeyPath<T, U>, value: U) throws -> T {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.affectedStores = [localPersistentStore]
        let stringValue = NSExpression(forKeyPath: attribute).keyPath
        request.predicate = NSPredicate(format: "\(stringValue) == %@", argumentArray: [value])
        guard let result = try context.fetch(request).first else {
            throw DatabaseError.notFound
        }
        return result
    }
    
    func create<T: NSManagedObject>(type: T.Type, storeType: StoreType = .local) -> T {
        let object = T(context: context)
        let store = storeType == .local ? localPersistentStore : cloudPersistentStore
        context.assign(object, to: store)
        return object
    }
    
    func save() throws {
        try saveContext()
    }
    
    func delete(object: NSManagedObject) throws {
        context.delete(object)
        try saveContext()
    }
    
    func deleteAll<T: NSManagedObject>(type: T.Type, storeType: StoreType) throws {
        let objects = try fetchAll(type: T.self, storeType: storeType)
        objects.forEach { context.delete($0) }
    }
    
    func upload<T: NSManagedObject>(with objects: [T]) throws {
        try deleteAll(type: T.self, storeType: .cloud)
        
        objects.forEach { object in
            context.assign(object, to: cloudPersistentStore)
        }
        try saveContext()
    }
    
    func download<T: NSManagedObject>(with objects: [T]) throws {
        try deleteAll(type: T.self, storeType: .local)
        
        objects.forEach { object in
            context.assign(object, to: localPersistentStore)
        }
        try saveContext()
    }
}
