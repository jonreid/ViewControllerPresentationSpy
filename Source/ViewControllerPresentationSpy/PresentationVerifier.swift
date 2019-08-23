//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

import XCTest
import UIKit

/**
    Captures presented view controllers.
 
    Instantiate a PresentationVerifier before the execution phase of the test. Then invoke the code
    to create and present your view controller. Information about the view controller is then
    available through the PresentationVerifier.
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
    @discardableResult public func verify<VC: UIViewController>(
            animated: Bool,
            presentingViewController: UIViewController? = nil,
            file: StaticString = #file,
            line: UInt = #line
    ) -> VC? {
        if presentedCount == 0 {
            XCTFail("present not called", file: file, line: line)
            return nil
        }
        if presentedCount > 1 {
            XCTFail("present called \(presentedCount) times", file: file, line: line)
        }
        if animated != self.animated {
            if animated {
                XCTFail("Expected animated present, but was not animated", file: file, line: line)
            } else {
                XCTFail("Expected non-animated present, but was animated", file: file, line: line)
            }
        }
        if let presentingViewController = presentingViewController {
            XCTAssertTrue(presentingViewController === self.presentingViewController,
                    "Expected presenting view controller to be \(presentingViewController)), " +
                            "but was \(String(describing: self.presentingViewController))",
                    file: file, line: line)
        }
        guard let nextVC = presentedViewController as? VC else {
            XCTFail("Expected presented view controller to be \(VC.self)), " +
                    "but was \(String(describing: presentedViewController))")
            return nil
        }
        return nextVC
    }
}
