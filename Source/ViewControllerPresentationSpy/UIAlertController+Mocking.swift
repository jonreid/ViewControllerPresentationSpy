// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

extension UIAlertController {
    static func swizzle() {
        replaceClassMethod(
            original: #selector(Self.init(title:message:preferredStyle:)),
            swizzled: #selector(mock_alertController(title:message:preferredStyle:))
        )

        replaceInstanceMethod(
            original: #selector(getter: preferredStyle),
            swizzled: #selector(getter: mock_preferredStyle)
        )

        #if os(iOS)
            replaceInstanceMethod(
                original: #selector(getter: popoverPresentationController),
                swizzled: #selector(getter: mock_popoverPresentationController)
            )
        #endif
    }

    @objc class func mock_alertController(
        title: String,
        message: String,
        preferredStyle: UIAlertController.Style
    ) -> UIAlertController {
        UIAlertController(mockWithTitle: title, message: message, preferredStyle: preferredStyle)
    }

    convenience init(mockWithTitle title: String, message: String, preferredStyle style: UIAlertController.Style) {
        self.init()
        self.title = title
        self.message = message
        attachExtraProperties(style: style)
    }

    func attachExtraProperties(style: Style) {
        objc_setAssociatedObject(
            self,
            UIAlertControllerExtraProperties.associatedObjectKey,
            UIAlertControllerExtraProperties(preferredStyle: style, alertController: self),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    @objc var mock_preferredStyle: UIAlertController.Style {
        guard let extraProperties = objc_getAssociatedObject(self, UIAlertControllerExtraProperties.associatedObjectKey)
            as? UIAlertControllerExtraProperties
        else {
            fatalError("Associated object UIAlertControllerExtraProperties not found")
        }
        return extraProperties.preferredStyle
    }

    #if os(iOS)
        @objc var mock_popoverPresentationController: UIPopoverPresentationController? {
            guard let extraProperties = objc_getAssociatedObject(self, UIAlertControllerExtraProperties.associatedObjectKey)
                as? UIAlertControllerExtraProperties
            else {
                print("ViewControllerPresentationSpy warning: Associated object UIAlertControllerExtraProperties not found. Another view controller is trying to access the swizzled popoverPresentationController before the UIAlertController is created.")
                return nil
            }
            return extraProperties.popover
        }
    #endif
}

private final class UIAlertControllerExtraProperties: NSObject {
    @MainActor fileprivate static let associatedObjectKey = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)

    let preferredStyle: UIAlertController.Style
    #if os(iOS)
        var popover: UIPopoverPresentationController?
    #endif

    @MainActor
    init(preferredStyle: UIAlertController.Style, alertController: UIAlertController) {
        self.preferredStyle = preferredStyle
        #if os(iOS)
            popover = UIPopoverPresentationController(presentedViewController: alertController, presenting: nil)
        #endif
        super.init()
    }
}
