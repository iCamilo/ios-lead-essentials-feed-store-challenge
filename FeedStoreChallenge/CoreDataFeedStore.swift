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
        let context = self.context
        
        context.perform {
            let cache = ManagedCache(context: context)
            cache.timestamp = timestamp
            cache.images = NSOrderedSet(array: feed.map {
                let managedFeedImage = ManagedFeedImage(context: context)
                managedFeedImage.id = $0.id
                managedFeedImage.url = $0.url
                managedFeedImage.imageDescription = $0.description
                managedFeedImage.location = $0.description
                
                return managedFeedImage
            })
            
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            do {
                let requestCache = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
                guard let managedCache = try context.fetch(requestCache).first else {
                    return completion(.empty)
                }
                
                let timestamp = managedCache.timestamp
                let localFeed = managedCache.images.compactMap{ $0 as? ManagedFeedImage }.map {
                    return LocalFeedImage(id: $0.id, description: $0.imageDescription, location: $0.location, url: $0.url)
                }
                
                completion(.found(feed: localFeed, timestamp: timestamp))
        } catch {
            completion(.failure(error))
        }
        }
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

@objc(ManagedFeedImage)
private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var images: NSOrderedSet
}
