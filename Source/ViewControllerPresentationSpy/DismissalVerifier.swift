//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2020 Quality Coding, Inc. See LICENSE.txt

import XCTest
import UIKit

/**
    Captures dismissed view controllers.
 
    Instantiate a DismissalVerifier before the execution phase of the test. Then invoke the code to
    dismiss your view controller. Information about the dismissal is then available through the
    DismissalVerifier.
 */
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

    static private(set) var isSwizzled = false

    /**
        Initializes a newly allocated verifier.
     
        Instantiating a DismissalVerifier swizzles UIViewController. It remains swizzled until the
        DismissalVerifier is deallocated. Only one DismissalVerifier may exist at a time.
     */
    @objc public override init() {
        super.init()
        guard !DismissalVerifier.isSwizzled else {
            XCTFail("""
                    More than one instance of DismissalVerifier exists. This may be caused by \
                    creating one setUp() but failing to set the property to nil in tearDown().
                    """)
            return
        }
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(viewControllerWasDismissed(_:)),
                name: NSNotification.Name.QCOMockViewControllerDismissed,
                object: nil
        )
        DismissalVerifier.swizzleMocks()
    }

    deinit {
        DismissalVerifier.swizzleMocks()
        NotificationCenter.default.removeObserver(self)
    }

    private static func swizzleMocks() {
        UIViewController.qcoMock_swizzleCaptureDismiss()
        DismissalVerifier.isSwizzled.toggle()
    }

    @objc private func viewControllerWasDismissed(_ notification: Notification) {
        dismissedCount += 1
        dismissedViewController = notification.object as? UIViewController
        animated = (notification.userInfo?[QCOMockViewControllerAnimatedKey] as? NSNumber)?.boolValue ?? false
        let closureContainer = notification.userInfo?[QCOMockViewControllerCompletionKey] as? ClosureContainer
        capturedCompletion = closureContainer?.closure
        if let completion = testCompletion {
            completion()
        }
    }
}

extension DismissalVerifier {
    /**
        Verifies dismissal of one view controller.
    */
    public func verify(
            animated: Bool,
            dismissedViewController: UIViewController? = nil,
            file: StaticString = #file,
            line: UInt = #line
    ) {
        let abort = verifyCallCount(actual: self.dismissedCount, action: "dismiss", file: file, line: line)
        if abort { return }
        verifyAnimated(actual: self.animated, expected: animated, action: "dismiss", file: file, line: line)
        verifyViewController(actual: self.dismissedViewController, expected: dismissedViewController,
                adjective: "dismissed", file: file, line: line)
    }
}
