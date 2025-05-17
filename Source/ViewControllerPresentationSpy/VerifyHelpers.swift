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

func verifyCalledOnce(actual: Int, action: String, file: StaticString, line: UInt) -> Bool {
    if actual == 0 {
        XCTFail("\(action) not called", file: file, line: line)
        return false // Abort test
    }
    if actual > 1 {
        XCTFail("\(action) called \(actual) times", file: file, line: line)
    }
    return true // Continue test
}

func verifyAnimated(actual: Bool, expected: Bool, action: String, file: StaticString, line: UInt) {
    if actual == expected { return }
    let message = expected ? "Expected animated \(action), but was not animated"
        : "Expected non-animated \(action), but was animated"
    XCTFail(message, file: file, line: line)
}

func verifyViewController(
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
