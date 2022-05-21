//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

import UIKit

extension UIViewController {
    // + (void)qcoMock_swizzleCaptureAlert
    // {
    // [self qcoMockAlerts_replaceInstanceMethod:@selector(presentViewController:animated:completion:)
    //        withMethod:@selector(qcoMock_presentViewControllerCapturingAlert:animated:completion:)];
    // }

    class func qcoMock_swizzleCaptureAlert2() {
        UIViewController.qcoMockAlerts_replaceInstanceMethod(
            #selector(UIViewController.present(_:animated:completion:)),
            withMethod: #selector(UIViewController.qcoMock_presentCapturingAlert(_:animated:completion:))
        )
    }
}
