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

    @objc func qcoMock_presentViewControllerCapturingAlert2(
        viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?
    ) {
        guard viewControllerToPresent.isKind(of: UIAlertController.self) else { return }
        let closureContainer = getClosureContainer(viewControllerToPresent: viewControllerToPresent, completion: completion)
        sendAlertInfo(viewControllerToPresent: viewControllerToPresent, animated: flag, closureContainer: closureContainer)
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

/*
  - (void)qcoMock_presentViewControllerCapturingAlert:(UIViewController *)viewControllerToPresent
                                            animated:(BOOL)flag
                                          completion:(void (^ __nullable)(void))completion
 {
     if (![viewControllerToPresent isKindOfClass:[UIAlertController class]])
         return;

     QCOClosureContainer *closureContainer = [self getClosureContainerWithViewControllerToPresent:viewControllerToPresent completion:completion];
     [self sendAlertInfoWithViewControllerToPresent:viewControllerToPresent animated:flag closureContainer:closureContainer];
 }
  */
