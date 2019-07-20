//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

import UIKit

/*!
 * @abstract Captures presented UIAlertControllers.
 * @discussion Instantiate an AlertVerifier before the execution phase of the test. Then
 * invoke the code to create and present your alert. Information about the alert is then available
 * through the AlertVerifier.
 */
@objc(QCOMockAlertVerifier2)
public class AlertVerifier: NSObject {
    @objc public var presentedCount = 0
    @objc public var presentedViewController: UIViewController?
    @objc public var presentingViewController: UIViewController?
    @objc public var animated: Bool = false
    @objc public var completion: (() -> Void)?

    /*!
     * @abstract Initializes a newly allocated verifier.
     * @discussion Instantiating an AlertVerifier swizzles UIViewController and UIAlertController. They remain swizzled
     * until the AlertVerifier is deallocated.
     */
    @objc public override init() {
        super.init()
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(viewControllerWasPresented(_:)),
                name: NSNotification.Name.QCOMockViewControllerPresented,
                object: nil
        )
        AlertVerifier.swizzleMocks()
    }

    deinit {
        AlertVerifier.swizzleMocks()
        NotificationCenter.default.removeObserver(self)
    }

    private static func swizzleMocks() {
        UIViewController.qcoMock_swizzleCaptureAlert()
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
