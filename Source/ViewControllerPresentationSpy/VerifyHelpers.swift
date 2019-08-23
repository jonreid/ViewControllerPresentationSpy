import UIKit
import XCTest

func verifyPresentedCount(actual: Int, file: StaticString, line: UInt) -> Bool {
    if actual == 0 {
        XCTFail("present not called", file: file, line: line)
        return true // Abort test
    }
    if actual > 1 {
        XCTFail("present called \(actual) times", file: file, line: line)
    }
    return false // Continue test
}

func verifyAnimated(actual: Bool, expected: Bool, file: StaticString, line: UInt) {
    if actual != expected {
        if expected {
            XCTFail("Expected animated present, but was not animated", file: file, line: line)
        } else {
            XCTFail("Expected non-animated present, but was animated", file: file, line: line)
        }
    }
}

func verifyPresentingViewController(actual: UIViewController?,
                                    expected: UIViewController?,
                                    file: StaticString,
                                    line: UInt) {
    if let expected = expected, let actual = actual {
        XCTAssertTrue(
                expected === actual,
                "Expected presenting view controller to be \(expected)), but was \(actual)",
                file: file,
                line: line)
    }
}
