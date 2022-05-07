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

    @objc class func qcoMock_action(withTitle title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let action = UIAlertAction.qcoMock_action(withTitle: title, style: style, handler: handler)
        let extraProperties = UIAlertActionExtraProperties(handler: handler)
        objc_setAssociatedObject(action, foo, extraProperties, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return action
    }
}

public final class UIAlertActionExtraProperties: NSObject {
    @objc public static let associatedObjectKey = "extraProperties"

    @objc public let handler: ((UIAlertAction) -> Void)?

    init(handler: ((UIAlertAction) -> Void)?) {
        self.handler = handler
        super.init()
    }
}
