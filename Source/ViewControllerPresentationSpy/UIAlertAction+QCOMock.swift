//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

import UIKit

extension UIAlertAction {
    @objc class func qcoMock_swizzle() {
        UIAlertAction.qcoMockAlerts_replaceClassMethod(
                #selector(UIAlertAction.init(title:style:handler:)),
                withMethod: #selector(UIAlertAction.qcoMock_action(withTitle:style:handler:))
        )
    }
}
