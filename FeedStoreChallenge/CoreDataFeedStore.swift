//  Created by Ivan Fuertes on 23/06/20.
//  Copyright © 2020 Essential Developer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let modelName = "FeedStore"
    private var persistenceStoreDescriptions: String {
        return container.persistentStoreDescriptions.description
    }
    
    public enum Error: Swift.Error {
        case modelNotFound
        case loadingPersistentStores
    }
    
    public let container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: modelName)
    }
    
    public init(bundle: Bundle) throws {
        guard let model = NSManagedObjectModel.with(name: modelName, in: bundle) else {
            throw Error.modelNotFound
        }
        
        var loadPersistenceError: Swift.Error?
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                return loadPersistenceError = error
            }
        }
        
        guard loadPersistenceError == nil else {
            throw Error.loadingPersistentStores
        }        
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
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
