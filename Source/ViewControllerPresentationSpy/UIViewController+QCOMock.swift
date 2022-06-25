// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

public extension UIViewController {
    class func qcoMock_swizzleCaptureAlert() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            #selector(Self.present(_:animated:completion:)),
            withMethod: #selector(Self.qcoMock_presentViewControllerCapturingAlert(viewControllerToPresent:animated:completion:))
        )
    }

    class func qcoMock_swizzleCapturePresent() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            #selector(Self.present(_:animated:completion:)),
            withMethod: #selector(Self.qcoMock_presentViewControllerCapturingIt(viewControllerToPresent:animated:completion:))
        )
    }

    class func qcoMock_swizzleCaptureDismiss2() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            #selector(Self.dismiss(animated:completion:)),
            withMethod: #selector(Self.qcoMock_dismissViewController(animated:completion:))
        )
    }

    @objc func qcoMock_presentViewControllerCapturingAlert(
        viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?
    ) {
        guard viewControllerToPresent.isKind(of: UIAlertController.self) else { return }
        viewControllerToPresent.loadViewIfNeeded()
        let closureContainer = ClosureContainer(closure: completion)
        let nc = NotificationCenter.default
        nc.post(
            name: NSNotification.Name.QCOMockAlertControllerPresented,
            object: viewControllerToPresent,
            userInfo: [
                QCOMockViewControllerPresentingViewControllerKey: self,
                QCOMockViewControllerAnimatedKey: flag,
                QCOMockViewControllerCompletionKey: closureContainer,
            ]
        )
    }

    @objc func qcoMock_presentViewControllerCapturingIt(
        viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?
    ) {
        viewControllerToPresent.loadViewIfNeeded()
        let closureContainer = ClosureContainer(closure: completion)
        NotificationCenter.default.post(
            name: NSNotification.Name.QCOMockViewControllerPresented,
            object: viewControllerToPresent,
            userInfo: [
                QCOMockViewControllerPresentingViewControllerKey: self,
                QCOMockViewControllerAnimatedKey: flag,
                QCOMockViewControllerCompletionKey: closureContainer,
            ]
        )
    }

    @objc func qcoMock_dismissViewController(animated flag: Bool, completion: (() -> Void)?) {
        let closureContainer = ClosureContainer(closure: completion)
        NotificationCenter.default.post(
            name: NSNotification.Name.QCOMockViewControllerDismissed,
            object: self,
            userInfo: [
                QCOMockViewControllerAnimatedKey: flag,
                QCOMockViewControllerCompletionKey: closureContainer,
            ]
        )
    }
}
