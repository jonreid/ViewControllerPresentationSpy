// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit
import XCTest

func verifyEqual<T: Equatable>(_ actual: T, _ expected: T, message: String? = nil, file: StaticString, line: UInt) {
    if actual != expected {
        let message = message.map { "- \($0)" } ?? ""
        XCTFail("Expected \(expected), but was \(actual)\(message)", file: file, line: line)
    }
}

func verifyCalledOnce(actual: Int, action: String, file: StaticString, line: UInt) -> Bool {
    if actual == 0 {
        XCTFail("\(action) not called", file: file, line: line)
        return true // Abort test
    }
    if actual > 1 {
        XCTFail("\(action) called \(actual) times", file: file, line: line)
    }
    return false // Continue test
}

func verifyAnimated(actual: Bool, expected: Bool, action: String, file: StaticString, line: UInt) {
    guard actual != expected else { return }
    let message = expected ? "Expected animated \(action), but was not animated"
        : "Expected non-animated \(action), but was animated"
    XCTFail(message, file: file, line: line)
}

func verifyViewController(
    actual: UIViewController?,
    expected: UIViewController?,
    adjective: String,
    file: StaticString,
    line: UInt
) {
    guard let expected, let actual else { return }
    XCTAssertTrue(
        expected === actual,
        "Expected \(adjective) view controller to be \(expected)), but was \(actual)",
        file: file,
        line: line)
}
