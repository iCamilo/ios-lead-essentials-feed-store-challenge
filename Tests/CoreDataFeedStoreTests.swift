//  Created by Ivan Fuertes on 23/06/20.
//  Copyright © 2020 Essential Developer. All rights reserved.

import XCTest
import FeedStoreChallenge

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }

    func test_insert_deliversNoErrorOnEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    func test_insert_overridesPreviouslyInsertedCacheValues() {
//        let sut = makeSUT()
//
//        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }

    func test_delete_deliversNoErrorOnEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }

    func test_delete_hasNoSideEffectsOnEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }

    func test_delete_deliversNoErrorOnNonEmptyCache() {
//        let sut = makeSUT()
//
//        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    func test_delete_emptiesPreviouslyInsertedCache() {
//        let sut = makeSUT()
//
//        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }

    func test_storeSideEffects_runSerially() {
//        let sut = makeSUT()
//
//        assertThatSideEffectsRunSerially(on: sut)
    }
    
    // - MARK: Setup tests would be deleted once setup is complete
        
    func test_persistenStoreExist_init_doesNotThrowError() {
        do {
            let modelBundle = Bundle(for: CoreDataFeedStore.self)
            let sut = try CoreDataFeedStore(bundle: modelBundle)
            XCTAssertNotNil(sut.container, "sut container should not be nil if the persistence store exists")
        } catch {
            XCTFail("If model file does exist, no error should be thrown")
        }
    }
    
    func test_persistenStoreExist_init_managedContextExists() {
        do {
            let modelBundle = Bundle(for: CoreDataFeedStore.self)
            let sut = try CoreDataFeedStore(bundle: modelBundle)
            XCTAssertNotNil(sut.context, "sut context should not be nil if the persistence store exists")
        } catch {
            XCTFail("If model file does exist, no error should be thrown")
        }
    }

    // - MARK: Helpers
    
    private func makeSUT() -> FeedStore {
        let sut = CoreDataFeedStore()
        
        return sut
    }
    
}

