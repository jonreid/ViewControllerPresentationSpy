// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit
import XCTest

/**
    Captures presented view controllers.

    Instantiate a PresentationVerifier before the execution phase of the test. Then invoke the code
    to create and present your view controller. Information about the presentation is then available
    through the PresentationVerifier.
 */
@MainActor
@objc(QCOPresentationVerifier)
public class PresentationVerifier: NSObject {
    /// Number of times present(_:animated:completion:) was called.
    @objc public var presentedCount = 0

    @objc public var presentedViewController: UIViewController?
    @objc public var presentingViewController: UIViewController?
    @objc public var animated: Bool = false

    /// Production code completion handler passed to present(_:animated:completion:).
    @objc public var capturedCompletion: (() -> Void)?

    /// Test code can provide its own completion handler to fulfill XCTestExpectations.
    @objc public var testCompletion: (() -> Void)?

    private(set) static var isSwizzled = false

    /**
        Initializes a newly allocated verifier.

        Instantiating a PresentationVerifier swizzles UIViewController. It remains swizzled until
        the PresentationVerifier is deallocated. Only one PresentationVerifier may exist at a time,
        and none may be created while an AlertVerifier exists. (This is because they both swizzle
        UIViewController.)
     */
    @objc override public init() {
        super.init()
        guard !PresentationVerifier.isSwizzled else {
            Fail().fail(
                message: """
                    More than one instance of PresentationVerifier exists. This may be caused by \
                    creating one setUp() but failing to set the property to nil in tearDown().
                    """,
                location: SourceLocation(fileID: #fileID, filePath: #filePath, line: #line, column: #column)
            )
            return
        }
        guard !AlertVerifier.isSwizzled else {
            Fail().fail(
                message: """
                    A PresentationVerifier may not be created while an AlertVerifier exists. Try \
                    making the AlertVerifier optional, and setting it to nil before creating the \
                    PresentationVerifier.
                    """,
                location: SourceLocation(fileID: #fileID, filePath: #filePath, line: #line, column: #column)
            )
            return
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewControllerWasPresented(_:)),
            name: Notification.Name.viewControllerPresented,
            object: nil
        )
        PresentationVerifier.swizzleMocksIgnoringActorIsolation()
    }

    deinit {
        PresentationVerifier.swizzleMocksIgnoringActorIsolation()
        NotificationCenter.default.removeObserver(self)
    }

    private nonisolated static func swizzleMocksIgnoringActorIsolation() {
        perform(#selector(swizzleMocks))
    }

    @objc private static func swizzleMocks() {
        UIViewController.swizzleCapturePresent()
        PresentationVerifier.isSwizzled.toggle()
    }

    @objc private func viewControllerWasPresented(_ notification: Notification) {
        presentedCount += 1
        presentedViewController = notification.object as? UIViewController
        presentingViewController = notification.userInfo?[presentingViewControllerKey] as? UIViewController
        animated = (notification.userInfo?[animatedKey] as? NSNumber)?.boolValue ?? false
        let closureContainer = notification.userInfo?[completionKey] as? ClosureContainer
        capturedCompletion = closureContainer?.closure
        if let completion = testCompletion {
            completion()
        }
    }
}

public extension PresentationVerifier {
    /**
         Verifies presentation of one view controller.
     */
    @discardableResult func verify<VC: UIViewController>(
        animated: Bool,
        presentingViewController: UIViewController? = nil,
        fileID: String = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        failure: any Failing = Fail()
    ) -> VC? {
        let continueTest = verifyCalledOnce(
            count: presentedCount,
            action: "present",
            fileID: fileID,
            filePath: filePath,
            line: line,
            failure: failure
        )
        guard continueTest else { return nil }
        verifyAnimated(
            actual: self.animated,
            expected: animated,
            action: "present",
            fileID: fileID,
            filePath: filePath,
            line: line,
            failure: failure
        )
        verifyIdentical(
            actual: self.presentingViewController,
            expected: presentingViewController,
            message: "presenting view controller",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        let nextVC: VC? = verifyViewController(
            self.presentedViewController,
            expectedType: VC.self,
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        return nextVC
    }
}
