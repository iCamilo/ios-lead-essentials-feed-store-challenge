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
        let context = self.context
        
        context.perform {
            do {
                try CoreDataFeedStore.deleteAllManagedCache(in: context)
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let context = self.context
        
        context.perform {
            do {
                try CoreDataFeedStore.deleteAllManagedCache(in: context)
                
                ManagedCache.mapFrom((timestamp: timestamp, images: feed), in: context)
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
                let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
                guard let managedCache = try context.fetch(request).first else {
                    return completion(.empty)
                }
                
                let retrieveResult = managedCache.mapTo()
                
                completion(.found(feed: retrieveResult.feed, timestamp: retrieveResult.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
            
    private static func deleteAllManagedCache(in context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        let caches = try context.fetch(request)
        
        _ = caches.map { context.delete($0) }
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
    
    static func mapFrom(_ localImage: LocalFeedImage, in context: NSManagedObjectContext) -> ManagedFeedImage {
        let managed = ManagedFeedImage(context: context)
        managed.id = localImage.id
        managed.url = localImage.url
        managed.imageDescription = localImage.description
        managed.location = localImage.description
        
        return managed
    }
        
    func mapTo() -> LocalFeedImage {
        return LocalFeedImage(id: id,
                              description: imageDescription,
                              location: location,
                              url: url)
    }
        
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var images: NSOrderedSet
    
    @discardableResult
    static func mapFrom(_ info: (timestamp: Date, images: [LocalFeedImage]), in context: NSManagedObjectContext) -> ManagedCache {
        let cache = ManagedCache(context: context)
        cache.timestamp = info.timestamp
        cache.images = NSOrderedSet(array: info.images.map {
            return ManagedFeedImage.mapFrom($0, in: context)
        })
        
        return cache
    }
    
    func mapTo() -> (feed: [LocalFeedImage], timestamp: Date){
        let feed = images.compactMap{ $0 as? ManagedFeedImage }.map {
            return $0.mapTo()
        }
        
        return(feed: feed, timestamp: self.timestamp)
    }
}
