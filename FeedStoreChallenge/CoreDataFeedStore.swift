//  Created by Ivan Fuertes on 23/06/20.
//  Copyright © 2020 Essential Developer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let modelName = "FeedStore"
    private var persistenceStoreDescription: String {
        return container.persistentStoreDescriptions.description
    }
            
    public let container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: modelName)
    }
    
    public init(bundle: Bundle) throws {
        container = try NSPersistentContainer.load(modelName: modelName, in: bundle)
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
    enum CoreDataStackConfigurationError: Error {
        case modelNotFound
        case loadingPersistentStores(Error)
    }
    
    static func load(modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw CoreDataStackConfigurationError.modelNotFound
        }
        
        var loadPersistenceError: Error?
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            loadPersistenceError = error
        }
        
        if let loadPersistenceError = loadPersistenceError {
            throw CoreDataStackConfigurationError.loadingPersistentStores(loadPersistenceError)
        }
        
        return container
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
