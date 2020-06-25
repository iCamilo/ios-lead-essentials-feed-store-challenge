//  Created by Ivan Fuertes on 23/06/20.
//  Copyright © 2020 Essential Developer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let modelName = "FeedStore"
                
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
        
    public init(bundle: Bundle = .main, storeURL: URL) throws {
        container = try NSPersistentContainer.load(modelName: modelName, in: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

internal extension NSPersistentContainer {
    enum ConfigurationError: Error {
        case modelNotFound
        case loadingPersistentStores(Error)
    }
    
    static func load(modelName name: String, in bundle: Bundle, storeURL: URL) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw ConfigurationError.modelNotFound
        }
                        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [storeDescription]
        
        try container.loadPersistentStores()
        
        return container
    }
    
    private func loadPersistentStores() throws {
        var loadStoresError: Error?
        loadPersistentStores { _, error in
            loadStoresError = error
        }
        
        if let loadStoresError = loadStoresError {
            throw ConfigurationError.loadingPersistentStores(loadStoresError)
        }
    }
}

internal extension NSManagedObjectModel {
    private static var coreDataModelsExtension: String {
        return "momd"
    }
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        guard let modelURL = bundle.url(forResource: name, withExtension: coreDataModelsExtension) else {
                return nil
        }
        
        return NSManagedObjectModel(contentsOf: modelURL)
    }
}

private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var images: NSOrderedSet
}
