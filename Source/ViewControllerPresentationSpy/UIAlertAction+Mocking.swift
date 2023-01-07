// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

extension UIAlertAction {
    static func swizzle() {
        Self.replaceClassMethod(
            original: #selector(Self.init(title:style:handler:)),
            swizzled: #selector(Self.mock_action(withTitle:style:handler:))
        )
    }

    @objc class func mock_action(withTitle title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let action = Self.mock_action(withTitle: title, style: style, handler: handler)
        let extraProperties = UIAlertActionExtraProperties(handler: handler)
        objc_setAssociatedObject(action, UIAlertActionExtraProperties.associatedObjectKey, extraProperties, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return action
    }

    func handler() -> ((UIAlertAction) -> Void)? {
        guard let extraProperties: UIAlertActionExtraProperties = objc_getAssociatedObject(self, UIAlertActionExtraProperties.associatedObjectKey)
            as? UIAlertActionExtraProperties
        else {
            return nil
        }
        return extraProperties.handler
    }
}

private final class UIAlertActionExtraProperties: NSObject {
    fileprivate static let associatedObjectKey = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)

    public let handler: ((UIAlertAction) -> Void)?

    init(handler: ((UIAlertAction) -> Void)?) {
        self.handler = handler
        super.init()
    }
}
