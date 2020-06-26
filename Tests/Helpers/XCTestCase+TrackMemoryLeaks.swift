//  Created by Ivan Fuertes on 25/06/20.
//  Copyright © 2020 Essential Developer. All rights reserved.

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeak(in instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be correctly deallocated to avoid memory leaks", file: file, line: line)
        }
    }
}
