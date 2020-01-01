//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2020 Quality Coding, Inc. See LICENSE.txt

import XCTest
import UIKit

/**
    Captures presented view controllers.
 
    Instantiate a PresentationVerifier before the execution phase of the test. Then invoke the code
    to create and present your view controller. Information about the presentation is then available
    through the PresentationVerifier.
 */
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

    /**
        Initializes a newly allocated verifier.
     
        Instantiating a PresentationVerifier swizzles UIViewController. It remains swizzled until
        the PresentationVerifier is deallocated.
     */
    @objc public override init() {
        super.init()
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(viewControllerWasPresented(_:)),
                name: NSNotification.Name.QCOMockViewControllerPresented,
                object: nil
        )
        PresentationVerifier.swizzleMocks()
    }

    deinit {
        PresentationVerifier.swizzleMocks()
        NotificationCenter.default.removeObserver(self)
    }

    private static func swizzleMocks() {
        UIViewController.qcoMock_swizzleCapture()
    }

    @objc private func viewControllerWasPresented(_ notification: Notification) {
        presentedCount += 1
        presentedViewController = notification.object as? UIViewController
        presentingViewController = notification.userInfo?[QCOMockViewControllerPresentingViewControllerKey] as? UIViewController
        animated = (notification.userInfo?[QCOMockViewControllerAnimatedKey] as? NSNumber)?.boolValue ?? false
        let closureContainer = notification.userInfo?[QCOMockViewControllerCompletionKey] as? ClosureContainer
        capturedCompletion = closureContainer?.closure
        if let completion = testCompletion {
            completion()
        }
    }
}

extension PresentationVerifier {
    /**
        Verifies presentation of one view controller.
    */
    @discardableResult public func verify<VC: UIViewController>(
            animated: Bool,
            presentingViewController: UIViewController? = nil,
            file: StaticString = #file,
            line: UInt = #line
    ) -> VC? {
        let abort = verifyCallCount(actual: self.presentedCount, action: "present", file: file, line: line)
        if abort { return nil }
        verifyAnimated(actual: self.animated, expected: animated, action: "present", file: file, line: line)
        verifyViewController(actual: self.presentingViewController, expected: presentingViewController,
                adjective: "presenting", file: file, line: line)
        let nextVC = presentedViewController as? VC
        if nextVC == nil {
            XCTFail("Expected presented view controller to be \(VC.self)), " +
                    "but was \(String(describing: presentedViewController))", file: file, line: line)
        }
        return nextVC
    }
}
