// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit
import XCTest

func assertEqual<T: Equatable>(
    actual: T,
    expected: T,
    message: String? = nil,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = FailReal()
) {
    if actual == expected { return }
    let message = message.map { " - \($0)" } ?? ""
    failure.fail(
        message: "Expected \(expected), but was \(actual)\(message)",
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

func assertIdentical<T: AnyObject>(
    actual: T,
    expected: T,
    message: String? = nil,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = FailReal()
) {
    if actual === expected { return }
    let message = message.map { " - \($0)" } ?? ""
    failure.fail(
        message: "Expected same instance as \(expected), but was \(actual)\(message)",
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

func assertIdentical<T: AnyObject>(
    actual: T?,
    expected: T?,
    message: String? = nil,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = FailReal()
) {
    guard let expected, let actual else { return }
    assertIdentical(
        actual: actual,
        expected: expected,
        message: message,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column,
        failure: failure
    )
}

func assertCalledOnce(
    count: Int,
    action: String,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = FailReal()
) -> Bool {
    if count == 0 {
        failure.fail(
            message: "\(action) not called",
            location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
        return false // Abort test
    }
    if count > 1 {
        failure.fail(
            message: "\(action) called \(count) times, expected once",
            location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
    }
    return true // Continue test
}

func assertAnimated(
    actual: Bool,
    expected: Bool,
    action: String,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = FailReal()
) {
    if actual == expected { return }
    let message = expected ? "Expected animated \(action), but was not animated"
        : "Expected non-animated \(action), but was animated"
    failure.fail(
        message: message,
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

/// Verifies that actual object is of the expected type, returning downcast instance if successful.
/// Otherwise, it fails the test reporting the actual type, and returns nil.
@discardableResult
func assertType<BaseClass, Specific>(
    _ actual: BaseClass?,
    expectedType: Specific.Type,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = FailReal()
) -> Specific? {
    guard let typed = actual as? Specific else {
        failure.fail(
            message: "Expected \(Specific.self), but was \(String(describing: actual))",
            location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
        return nil
    }
    return typed
}
