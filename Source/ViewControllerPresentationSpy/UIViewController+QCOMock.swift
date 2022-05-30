// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

public extension UIViewController {
    internal class func qcoMock_swizzleCaptureAlert() {
        UIViewController.qcoMockAlerts_replaceInstanceMethod(
            #selector(UIViewController.present(_:animated:completion:)),
            withMethod: #selector(UIViewController.qcoMock_presentCapturingAlert(_:animated:completion:))
        )
    }

    @objc func sendAlertInfo(viewControllerToPresent: UIViewController, animated flag: Bool, closureContainer: ClosureContainer) {
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

    @objc func getClosureContainer(viewControllerToPresent: UIViewController, completion: (() -> Void)?) -> ClosureContainer {
        viewControllerToPresent.loadViewIfNeeded()
        return ClosureContainer(closure: completion)
    }
}
