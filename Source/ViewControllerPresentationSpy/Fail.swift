// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import XCTest

#if canImport(Testing)
import Testing
#endif

public protocol Failing {
    func fail(message: String, location: SourceLocation)
}

public struct Fail: Failing {
    public init() {}
    
    public func fail(message: String, location: SourceLocation) {
        if isRunningSwiftTest() {
#if canImport(Testing)
            Issue.record(Testing.Comment(rawValue: message), sourceLocation: location.toTestingSourceLocation())
#endif
            return
        }

        XCTFail(message, file: location.filePath, line: location.line)
    }

    private func isRunningSwiftTest() -> Bool {
#if canImport(Testing)
        Test.current != nil
#else
        false
#endif
    }
}

public struct SourceLocation {
    public let fileID: String
    public let filePath: StaticString
    public let line: UInt
    public let column: UInt

#if canImport(Testing)
    public func toTestingSourceLocation() -> Testing.SourceLocation {
        Testing.SourceLocation(fileID: fileID, filePath: "\(filePath)", line: Int(line), column: Int(column))
    }
#endif
}
