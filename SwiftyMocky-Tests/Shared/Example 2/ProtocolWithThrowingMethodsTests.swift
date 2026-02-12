//
//  ProtocolWithThrowingMethodsTests.swift
//  Mocky_Tests
//
//  Created by Andrzej Michnia on 16.11.2017.
//  Copyright © 2017 MakeAWishFoundation. All rights reserved.
//

import XCTest
import SwiftyMocky
#if os(iOS)                                                                                        
@testable import Mocky_Example_iOS                                                             
#else                                                                                              
@testable import Mocky_Example_macOS                                                           
#endif

enum SimpleTestError: Error {
    case failure
    case other
}

class ProtocolWithThrowingMethodsTests: XCTestCase {

    func test_will_throw() {
        let mock = ProtocolWithThrowingMethodsMock()

        XCTAssertNoThrow(try mock.methodThatThrows(), "Should not throw right now")

        Given(mock, .methodThatThrows(willThrow: SimpleTestError.failure))
        XCTAssertThrowsError(try mock.methodThatThrows(), "Should throw error") { error in
            switch error {
            case SimpleTestError.failure: XCTAssert(true)
            default: XCTFail("Wrong error thrown - expected \(SimpleTestError.failure), got \(error)")
            }
        }

        Given(mock, .methodThatThrows(willThrow: SimpleTestError.other))
        XCTAssertThrowsError(try mock.methodThatThrows(), "Should throw error") { error in
            switch error {
            case SimpleTestError.other: XCTAssert(true)
            default: XCTFail("Wrong error thrown - expected \(SimpleTestError.other), got \(error)")
            }
        }
    }

    func test_throw_or_return() {
        let mock = ProtocolWithThrowingMethodsMock()

        Given(mock, .methodThatReturnsAndThrows(param: .value(200), willReturn: true))
        Given(mock, .methodThatReturnsAndThrows(param: .value(404), willThrow: SimpleTestError.failure))
        Given(mock, .methodThatReturnsAndThrows(param: .any, willThrow: SimpleTestError.other))

        XCTAssertNoThrow(try mock.methodThatReturnsAndThrows(param: 200), "Should not throw")
        XCTAssertThrowsError(try mock.methodThatReturnsAndThrows(param: 404))
        XCTAssertThrowsError(try mock.methodThatReturnsAndThrows(param: 123))

        Verify(mock, 3, .methodThatReturnsAndThrows(param: .any))
    }

    func test_will_throw_builderAPI() {
        let mock = ProtocolWithThrowingMethodsMock()

        XCTAssertNoThrow(try mock.methodThatThrows(), "Should not throw right now")

        // New builder API version
        given(mock).methodThatThrows().willThrow(SimpleTestError.failure)
        XCTAssertThrowsError(try mock.methodThatThrows(), "Should throw error") { error in
            switch error {
            case SimpleTestError.failure: XCTAssert(true)
            default: XCTFail("Wrong error thrown - expected \(SimpleTestError.failure), got \(error)")
            }
        }

        given(mock).methodThatThrows().willThrow(SimpleTestError.other)
        XCTAssertThrowsError(try mock.methodThatThrows(), "Should throw error") { error in
            switch error {
            case SimpleTestError.other: XCTAssert(true)
            default: XCTFail("Wrong error thrown - expected \(SimpleTestError.other), got \(error)")
            }
        }
    }

    func test_throw_or_return_builderAPI() {
        let mock = ProtocolWithThrowingMethodsMock()

        // New builder API version
        given(mock).methodThatReturnsAndThrows(param: .value(200)).willReturn(true)
        given(mock).methodThatReturnsAndThrows(param: .value(404)).willThrow(SimpleTestError.failure)
        given(mock).methodThatReturnsAndThrows(param: .any).willThrow(SimpleTestError.other)

        XCTAssertNoThrow(try mock.methodThatReturnsAndThrows(param: 200), "Should not throw")
        XCTAssertThrowsError(try mock.methodThatReturnsAndThrows(param: 404))
        XCTAssertThrowsError(try mock.methodThatReturnsAndThrows(param: 123))

        verify(mock, .exactly(3)).methodThatReturnsAndThrows(param: .any)
    }
}

