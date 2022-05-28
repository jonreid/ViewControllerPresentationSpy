//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

import UIKit

extension UIViewController {
    class func qcoMock_swizzleCaptureAlert() {
        UIViewController.qcoMockAlerts_replaceInstanceMethod(
            #selector(UIViewController.present(_:animated:completion:)),
            withMethod: #selector(UIViewController.qcoMock_presentCapturingAlert(_:animated:completion:))
        )
    }

    @objc public func sendAlertInfo(viewControllerToPresent: UIViewController, animated flag: Bool, closureContainer: ClosureContainer) {
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

/*
  - (void)viewControllerToPresent:(UIViewController *)viewControllerToPresent animated:(BOOL)flag closureContainer:(QCOClosureContainer *)closureContainer
 {
     NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
     [nc postNotificationName:QCOMockAlertControllerPresentedNotification
                       object:viewControllerToPresent
                     userInfo:@{
                             QCOMockViewControllerPresentingViewControllerKey: self,
                             QCOMockViewControllerAnimatedKey: @(flag),
                             QCOMockViewControllerCompletionKey: closureContainer,
                     }];
 }
  */
