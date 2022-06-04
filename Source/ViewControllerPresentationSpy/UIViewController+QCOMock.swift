// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

public extension UIViewController {
    internal class func qcoMock_swizzleCaptureAlert() {
        Self.qcoMockAlerts_replaceInstanceMethod(
            #selector(Self.present(_:animated:completion:)),
            withMethod: #selector(Self.qcoMock_presentViewControllerCapturingAlert(viewControllerToPresent:animated:completion:))
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
}
