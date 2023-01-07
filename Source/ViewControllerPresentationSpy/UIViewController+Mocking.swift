// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

let presentingViewControllerKey = "presentingViewControllerKey"
let animatedKey = "animatedKey"
let completionKey = "completionKey"

extension Notification.Name {
    static let viewControllerPresented = Notification.Name("viewControllerPresented")
    static let viewControllerDismissed = Notification.Name("viewControllerDismissed")
    static let alertControllerPresented = Notification.Name("alertControllerPresented")
}

extension UIViewController {
    static func swizzleCaptureAlert() {
        Self.replaceInstanceMethod(
            original: #selector(Self.present(_:animated:completion:)),
            swizzled: #selector(Self.mock_presentViewControllerCapturingAlert(viewControllerToPresent:animated:completion:))
        )
    }

    static func swizzleCapturePresent() {
        Self.replaceInstanceMethod(
            original: #selector(Self.present(_:animated:completion:)),
            swizzled: #selector(Self.mock_presentViewControllerCapturingIt(viewControllerToPresent:animated:completion:))
        )
    }

    static func swizzleCaptureDismiss() {
        Self.replaceInstanceMethod(
            original: #selector(Self.dismiss(animated:completion:)),
            swizzled: #selector(Self.mock_dismissViewController(animated:completion:))
        )
    }

    @objc func mock_presentViewControllerCapturingAlert(
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

    @objc func mock_presentViewControllerCapturingIt(
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

    @objc func mock_dismissViewController(animated flag: Bool, completion: (() -> Void)?) {
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
