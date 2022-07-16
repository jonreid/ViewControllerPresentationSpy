// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

extension UIAlertController {
    class func qcoMock_swizzle() {
        Self.qcoMockAlerts_replaceClassMethod(
            original: #selector(Self.init(title:message:preferredStyle:)),
            swizzled: #selector(Self.qcoMock_alertController(title:message:preferredStyle:))
        )

        Self.qcoMockAlerts_replaceInstanceMethod(
            original: #selector(getter: Self.preferredStyle),
            swizzled: #selector(getter: Self.qcoMock_preferredStyle)
        )

        #if os(iOS)
            Self.qcoMockAlerts_replaceInstanceMethod(
                original: #selector(getter: Self.popoverPresentationController),
                swizzled: #selector(getter: Self.qcoMock_popoverPresentationController)
            )
        #endif
    }

    @objc class func qcoMock_alertController(
        title: String,
        message: String,
        preferredStyle: UIAlertController.Style
    ) -> UIAlertController {
        UIAlertController(qcoMockWithTitle: title, message: message, preferredStyle: preferredStyle)
    }

    convenience init(qcoMockWithTitle title: String, message: String, preferredStyle style: UIAlertController.Style) {
        self.init()
        self.title = title
        self.message = message
        attachExtraProperties(style: style)
    }

    func attachExtraProperties(style: Style) {
        objc_setAssociatedObject(
            self,
            &UIAlertControllerExtraProperties.associatedObjectKey,
            UIAlertControllerExtraProperties(preferredStyle: style, alertController: self),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    @objc var qcoMock_preferredStyle: UIAlertController.Style {
        guard let extraProperties = objc_getAssociatedObject(self, &UIAlertControllerExtraProperties.associatedObjectKey)
            as? UIAlertControllerExtraProperties
        else {
            fatalError("Associated object UIAlertControllerExtraProperties not found")
        }
        return extraProperties.preferredStyle
    }

    #if os(iOS)
        @objc var qcoMock_popoverPresentationController: UIPopoverPresentationController? {
            guard let extraProperties = objc_getAssociatedObject(self, &UIAlertControllerExtraProperties.associatedObjectKey)
                as? UIAlertControllerExtraProperties
            else {
                fatalError("Associated object UIAlertControllerExtraProperties not found")
            }
            return extraProperties.popover
        }
    #endif
}

final class UIAlertControllerExtraProperties: NSObject {
    static var associatedObjectKey = "extraProperties"

    let preferredStyle: UIAlertController.Style
    #if os(iOS)
        var popover: UIPopoverPresentationController?
    #endif

    init(preferredStyle: UIAlertController.Style, alertController: UIAlertController) {
        self.preferredStyle = preferredStyle
        #if os(iOS)
            popover = UIPopoverPresentationController(presentedViewController: alertController, presenting: nil)
        #endif
        super.init()
    }
}
