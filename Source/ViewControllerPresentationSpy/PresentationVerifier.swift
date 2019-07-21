//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

import UIKit

/*!
 * @abstract Captures presented view controllers.
 * @discussion Instantiate a PresentationVerifier before the execution phase of the test. Then
 * invoke the code to create and present your view controller. Information about the view controller
 * is then available through the PresentationVerifier.
 */
@objc(QCOPresentationVerifier)
public class PresentationVerifier: NSObject {
    @objc public var presentedCount = 0
    @objc public var presentedViewController: UIViewController?
    @objc public var presentingViewController: UIViewController?
    @objc public var animated: Bool = false
    @objc public var completion: (() -> Void)?

    /*!
     * @abstract Initializes a newly allocated verifier.
     * @discussion Instantiating a PresentationVerifier swizzles UIViewController. It remains swizzled
     * until the PresentationVerifier is deallocated.
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
        if let completion = completion {
            completion()
        }
    }
}
