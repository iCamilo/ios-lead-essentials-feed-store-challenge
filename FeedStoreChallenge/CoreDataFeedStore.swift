//  Created by Ivan Fuertes on 23/06/20.
//  Copyright © 2020 Essential Developer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
        
    public enum Error: Swift.Error {
        case modelNotFound
    }
    
    public init() {}
    
    public init(bundle: Bundle) throws {
        guard let managedModelURL = bundle.url(forResource: "FeedStore", withExtension: "momd") else {
            throw Error.modelNotFound
        }
        guard let _ = NSManagedObjectModel(contentsOf: managedModelURL) else {
            throw Error.modelNotFound
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
