// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

let presentingViewControllerKey = "presentingViewControllerKey"
let animatedKey = "animatedKey"
let completionKey = "completionKey"

public extension Notification.Name {
    static let viewControllerPresented = Notification.Name("viewControllerPresented")
    static let viewControllerDismissed = Notification.Name("viewControllerDismissed")
    static let alertControllerPresented = Notification.Name("alertControllerPresented")
}

public extension UIViewController {
    static func qcoMock_swizzleCaptureAlert() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            original: #selector(Self.present(_:animated:completion:)),
            swizzled: #selector(Self.qcoMock_presentViewControllerCapturingAlert(viewControllerToPresent:animated:completion:))
        )
    }

    static func qcoMock_swizzleCapturePresent() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            original: #selector(Self.present(_:animated:completion:)),
            swizzled: #selector(Self.qcoMock_presentViewControllerCapturingIt(viewControllerToPresent:animated:completion:))
        )
    }

    static func qcoMock_swizzleCaptureDismiss() {
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
            name: Notification.Name.alertControllerPresented,
            object: viewControllerToPresent,
            userInfo: [
                presentingViewControllerKey: self,
                animatedKey: flag,
                completionKey: closureContainer,
            ]
        )
    }

    @objc func qcoMock_presentViewControllerCapturingIt(
        viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?
    ) {
        viewControllerToPresent.loadViewIfNeeded()
        let closureContainer = ClosureContainer(closure: completion)
        NotificationCenter.default.post(
            name: Notification.Name.viewControllerPresented,
            object: viewControllerToPresent,
            userInfo: [
                presentingViewControllerKey: self,
                animatedKey: flag,
                completionKey: closureContainer,
            ]
        )
    }

    @objc func qcoMock_dismissViewController(animated flag: Bool, completion: (() -> Void)?) {
        let closureContainer = ClosureContainer(closure: completion)
        NotificationCenter.default.post(
            name: Notification.Name.viewControllerDismissed,
            object: self,
            userInfo: [
                animatedKey: flag,
                completionKey: closureContainer,
            ]
        )
    }
}
