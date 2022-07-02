// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

let QCOMockViewControllerPresentingViewControllerKey = "QCOMockViewControllerPresentingViewControllerKey"
let QCOMockViewControllerAnimatedKey = "QCOMockViewControllerAnimatedKey"
let QCOMockViewControllerCompletionKey = "QCOMockViewControllerCompletionKey"

public extension Notification.Name {
    static let QCOMockViewControllerPresented2 = Notification.Name("QCOMockViewControllerPresented")
    static let QCOMockViewControllerDismissed2 = Notification.Name("QCOMockViewControllerDismissed")
    static let QCOMockAlertControllerPresented2 = Notification.Name("QCOMockAlertControllerPresented")
}

public extension UIViewController {
    class func qcoMock_swizzleCaptureAlert() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            original: #selector(Self.present(_:animated:completion:)),
            swizzled: #selector(Self.qcoMock_presentViewControllerCapturingAlert(viewControllerToPresent:animated:completion:))
        )
    }

    class func qcoMock_swizzleCapturePresent() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            original: #selector(Self.present(_:animated:completion:)),
            swizzled: #selector(Self.qcoMock_presentViewControllerCapturingIt(viewControllerToPresent:animated:completion:))
        )
    }

    class func qcoMock_swizzleCaptureDismiss() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            original: #selector(Self.dismiss(animated:completion:)),
            swizzled: #selector(Self.qcoMock_dismissViewController(animated:completion:))
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
            name: Notification.Name.QCOMockAlertControllerPresented2,
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
            name: Notification.Name.QCOMockViewControllerPresented2,
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
            name: Notification.Name.QCOMockViewControllerDismissed2,
            object: self,
            userInfo: [
                QCOMockViewControllerAnimatedKey: flag,
                QCOMockViewControllerCompletionKey: closureContainer,
            ]
        )
    }
}
