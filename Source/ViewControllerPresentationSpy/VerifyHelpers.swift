// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit
import XCTest
import Testing

func verifyCalledOnce(actual: Int, action: String, file: StaticString, line: UInt, sourceLocation: SourceLocation) -> Bool {
    if actual == 0 {
        fail("\(action) not called", file: file, line: line, sourceLocation: sourceLocation)
        return true // Abort test
    }
    if actual > 1 {
        fail("\(action) called \(actual) times", file: file, line: line, sourceLocation: sourceLocation)
    }
    return false // Continue test
}

func verifyAnimated(actual: Bool, expected: Bool, action: String, file: StaticString, line: UInt, sourceLocation: SourceLocation) {
    if actual != expected {
        if expected {
            fail("Expected animated \(action), but was not animated", file: file, line: line, sourceLocation: sourceLocation)
        } else {
            fail("Expected non-animated \(action), but was animated", file: file, line: line, sourceLocation: sourceLocation)
        }
    }
}

func verifyViewController(actual: UIViewController?,
                          expected: UIViewController?,
                          adjective: String,
                          file: StaticString,
                          line: UInt,
                          sourceLocation: SourceLocation) {
    if let expected = expected, let actual = actual {
        assertTrue(
                expected === actual,
                "Expected \(adjective) view controller to be \(expected)), but was \(actual)",
                file: file,
                line: line,
                sourceLocation: sourceLocation)
    }
}

func fail(_ comment: Comment,
          file: StaticString = #file,
          line: UInt = #line,
          sourceLocation: SourceLocation = #_sourceLocation) {
    XCTFail(comment.rawValue, file: file, line: line)
    Issue.record(comment, sourceLocation: sourceLocation)
}

func assertEqual<T>(_ expression1: @autoclosure () -> T,
                    _ expression2: @autoclosure () -> T,
                    _ comment: Comment? = nil,
                    file: StaticString = #filePath,
                    line: UInt = #line,
                    sourceLocation: SourceLocation = #_sourceLocation) where T : Equatable {
    XCTAssertEqual(expression1(), expression2(), comment?.rawValue ?? "", file: file, line: line)
    #expect(expression1() == expression2(), comment, sourceLocation: sourceLocation)
}


func assertTrue(_ expression: @autoclosure () -> Bool,
                _ comment: Comment? = nil,
                file: StaticString = #filePath,
                line: UInt = #line,
                sourceLocation: SourceLocation = #_sourceLocation) {
    XCTAssertTrue(expression(), comment?.rawValue ?? "", file: file, line: line)
    #expect(expression(), comment, sourceLocation: sourceLocation)
}
