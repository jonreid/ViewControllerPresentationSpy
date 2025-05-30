// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit
import XCTest

func verifyEqual<T: Equatable>(
    _ actual: T,
    _ expected: T,
    message: String? = nil,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
) {
    if actual == expected { return }
    let message = message.map { " - \($0)" } ?? ""
    failure.fail(
        message: "Expected \(expected), but was \(actual)\(message)",
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

func verifyIdentical<T: AnyObject>(
    _ actual: T,
    _ expected: T,
    message: String? = nil,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
) {
    if actual === expected { return }
    let message = message.map { " - \($0)" } ?? ""
    failure.fail(
        message: "Expected same instance as \(expected), but was \(actual)\(message)",
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

func verifyCalledOnce(
    count: Int,
    action: String,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
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

func verifyAnimated(
    actual: Bool,
    expected: Bool,
    action: String,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
) {
    if actual == expected { return }
    let message = expected ? "Expected animated \(action), but was not animated"
        : "Expected non-animated \(action), but was animated"
    failure.fail(
        message: message,
        location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

func verifyIdenticalViewController(
    actual: UIViewController?,
    expected: UIViewController?,
    adjective: String,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
) {
    guard let expected, let actual else { return }
    verifyIdentical(
        actual,
        expected,
        message: "\(adjective) view controller",
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column,
        failure: failure
    )
}

@discardableResult
func verifyViewController<ViewController>(
    _ actual: UIViewController?,
    expectedType: ViewController.Type,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    failure: any Failing = Fail()
) -> ViewController? {
    guard let typedVC = actual as? ViewController else {
        failure.fail(
            message: "Expected \(ViewController.self) but was \(String(describing: actual))",
            location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
        return nil
    }
    return typedVC
}
