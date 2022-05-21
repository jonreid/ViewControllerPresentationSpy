//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

import UIKit

extension UIViewController {
    class func qcoMock_swizzleCaptureAlert2() {
        UIViewController.qcoMockAlerts_replaceInstanceMethod(
            #selector(UIViewController.present(_:animated:completion:)),
            withMethod: #selector(UIViewController.qcoMock_presentCapturingAlert(_:animated:completion:))
        )
    }
}
