//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge

class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_insert_overridesPreviouslyInsertedCacheValues() {
		let sut = makeSUT()

		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}

	func test_delete_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_delete_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_delete_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_delete_emptiesPreviouslyInsertedCache() {
		let sut = makeSUT()

		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}

	func test_storeSideEffects_runSerially() {
		let sut = makeSUT()

		assertThatSideEffectsRunSerially(on: sut)
	}
    
    func test_onStoreDeallocation_delete_doesNotDeliverResults() {
        var sut: InMemoryFeedStore? = InMemoryFeedStore()
        
        sut?.deleteCachedFeed { _ in
            XCTFail("On store deallocation, delete operation SHOULD NOT deliver any result")
        }
        sut = nil
    }
    
    func test_onStoreDeallocation_insert_doesNotDeliverResults() {
        var sut: InMemoryFeedStore? = InMemoryFeedStore()
        
        sut?.insert(uniqueImageFeed(), timestamp: Date()) { _ in
            XCTFail("On store deallocation, insert operation SHOULD NOT deliver any result")
        }
        sut = nil
    }
    
    func test_onStoreDeallocation_retrieve_doesNotDeliverResults() {
        var sut: InMemoryFeedStore? = InMemoryFeedStore()
        
        sut?.retrieve { _ in
            XCTFail("On store deallocation, retrieve operation SHOULD NOT deliver any result")
        }
        sut = nil
    }
	
	// - MARK: Helpers
	
	private func makeSUT() -> FeedStore {
		let sut = InMemoryFeedStore()
        
        trackForMemoryLeak(in: sut, file: #file, line: #line)
        
        return sut
	}
    
}
