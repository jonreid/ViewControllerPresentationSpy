import UIKit

extension UIAlertController {
    
    @objc class func qcoMock_swizzle() {
        UIAlertController.qcoMockAlerts_replaceClassMethod(
                #selector(UIAlertController.init(title:message:preferredStyle:)),
                withMethod: #selector(UIAlertController.qcoMock_alertController(title:message:preferredStyle:))
        )

        UIAlertController.qcoMockAlerts_replaceInstanceMethod(
                #selector(getter: UIAlertController.preferredStyle),
                withMethod: #selector(getter: UIAlertController.qcoMock_preferredStyle)
        )

        #if (os(iOS))
            UIAlertController.qcoMockAlerts_replaceInstanceMethod(
                    #selector(getter: UIAlertController.popoverPresentationController),
                    withMethod: #selector(getter: UIAlertController.qcoMock_popoverPresentationController2)
            )
        #endif
    }
    
    @objc class func qcoMock_alertController(
            title: String,
            message: String,
            preferredStyle: UIAlertController.Style
    ) -> UIAlertController {
        UIAlertController.init(qcoMockWithTitle2: title, message: message, preferredStyle: preferredStyle)
    }
    
    @objc convenience init(qcoMockWithTitle2 title: String, message: String, preferredStyle style: UIAlertController.Style) {
        self.init()
        self.title = title
        self.message = message

        attachExtraProperties(style: style)

        #if os(iOS)
        // Intercept popover
        #endif
    }

    @objc public func attachExtraProperties(style: Style) {
        objc_setAssociatedObject(
                self,
                UIAlertControllerExtraProperties.associatedObjectKey,
                UIAlertControllerExtraProperties(preferredStyle: style, alertController: self),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    @objc var qcoMock_preferredStyle: UIAlertController.Style {
        guard let extraProperties = objc_getAssociatedObject(self, UIAlertControllerExtraProperties.associatedObjectKey)
                as? UIAlertControllerExtraProperties else {
            fatalError("Associated object UIAlertControllerExtraProperties not found")
        }
        return extraProperties.preferredStyle
    }
    
    #if os(iOS)
    @objc var qcoMock_popoverPresentationController2: UIPopoverPresentationController? {
        guard let extraProperties = objc_getAssociatedObject(self, UIAlertControllerExtraProperties.associatedObjectKey)
                as? UIAlertControllerExtraProperties else {
            fatalError("Associated object UIAlertControllerExtraProperties not found")
        }
        return extraProperties.mockPopover
    }
    #endif
}

class UIAlertControllerExtraProperties: NSObject {
    static let associatedObjectKey = "extraProperties"

    let preferredStyle: UIAlertController.Style
    #if os(iOS)
        var qcoMock_mockPopover2: QCOMockPopoverPresentationController?
        var mockPopover: UIPopoverPresentationController?
    #endif
        
    init(preferredStyle: UIAlertController.Style, alertController: UIAlertController) {
        self.preferredStyle = preferredStyle
        #if os(iOS)
            mockPopover = UIPopoverPresentationController(presentedViewController: alertController, presenting: nil)
        #endif
        super.init()
    }
}

#if os(iOS)
extension UIPopoverPresentationController {
    @objc convenience init(presentedViewController2: UIViewController, presenting presentingViewController: UIViewController?) {
        self.init(presentedViewController: presentedViewController2, presenting: presentingViewController)

        objc_setAssociatedObject(
                self,
                UIPopoverPresentationControllerExtraProperties.associatedObjectKey,
                UIPopoverPresentationControllerExtraProperties(),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
class UIPopoverPresentationControllerExtraProperties: NSObject {
    static let associatedObjectKey = "extraProperties"

    var arrowDirection: UIPopoverArrowDirection = .unknown
}
#endif
