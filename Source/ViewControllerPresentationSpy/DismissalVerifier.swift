// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit
import XCTest

/**
    Captures dismissed view controllers.

    Instantiate a DismissalVerifier before the execution phase of the test. Then invoke the code to
    dismiss your view controller. Information about the dismissal is then available through the
    DismissalVerifier.
 */
@MainActor
@objc(QCODismissalVerifier)
public class DismissalVerifier: NSObject {
    /// Number of times dismiss(_:completion:) was called.
    @objc public var dismissedCount = 0

    @objc public var dismissedViewController: UIViewController?
    @objc public var animated: Bool = false

    /// Production code completion handler passed to dismiss(_:completion:).
    @objc public var capturedCompletion: (() -> Void)?

    /// Test code can provide its own completion handler to fulfill XCTestExpectations.
    @objc public var testCompletion: (() -> Void)?

    private(set) static var isSwizzled = false

    /**
        Initializes a newly allocated verifier.

        Instantiating a DismissalVerifier swizzles UIViewController. It remains swizzled until the
        DismissalVerifier is deallocated. Only one DismissalVerifier may exist at a time.
     */
    @objc override public init() {
        super.init()
        guard !DismissalVerifier.isSwizzled else {
            Fail().fail(
                message: """
                    More than one instance of DismissalVerifier exists. This may be caused by \
                    creating one setUp() but failing to set the property to nil in tearDown().
                    """,
                location: SourceLocation(fileID: #fileID, filePath: #filePath, line: #line, column: #column)
            )
            return
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewControllerWasDismissed(_:)),
            name: Notification.Name.viewControllerDismissed,
            object: nil
        )
        DismissalVerifier.swizzleMocksIgnoringActorIsolation()
    }

    deinit {
        DismissalVerifier.swizzleMocksIgnoringActorIsolation()
        NotificationCenter.default.removeObserver(self)
    }

    private nonisolated static func swizzleMocksIgnoringActorIsolation() {
        perform(#selector(swizzleMocks))
    }

    @objc private static func swizzleMocks() {
        UIViewController.swizzleCaptureDismiss()
        DismissalVerifier.isSwizzled.toggle()
    }

    @objc private func viewControllerWasDismissed(_ notification: Notification) {
        dismissedCount += 1
        dismissedViewController = notification.object as? UIViewController
        animated = (notification.userInfo?[animatedKey] as? NSNumber)?.boolValue ?? false
        let closureContainer = notification.userInfo?[completionKey] as? ClosureContainer
        capturedCompletion = closureContainer?.closure
        if let completion = testCompletion {
            completion()
        }
    }
}

public extension DismissalVerifier {
    /**
         Verifies dismissal of one view controller.
     */
    func verify(
        animated: Bool,
        dismissedViewController: UIViewController? = nil,
        fileID: String = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        failure: any Failing = Fail()
    ) {
        let continueTest = verifyCalledOnce(
            count: dismissedCount,
            action: "dismiss",
            fileID: fileID,
            filePath: filePath,
            line: line,
            failure: failure
        )
        guard continueTest else { return }
        verifyAnimated(
            actual: self.animated,
            expected: animated,
            action: "dismiss",
            fileID: fileID,
            filePath: filePath,
            line: line,
            failure: failure
        )
        verifyIdentical(
            actual: self.dismissedViewController,
            expected: dismissedViewController,
            message: "dismissed view controller",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
    }
}
