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
                    withMethod: #selector(UIAlertController.qcoMock_popoverPresentationController)
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

        objc_setAssociatedObject(
                self,
                UIAlertControllerExtraProperties.associatedObjectKey,
                UIAlertControllerExtraProperties(preferredStyle: style, alertController: self),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        #if os(iOS)
            UIPopoverPresentationController(presentedViewController2: self, presenting: nil)
        #endif

//        #if TARGET_OS_IOS
//            self.qcoMock_mockPopover = [[QCOMockPopoverPresentationController alloc] init];
//        #endif


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
        return nil
//        return extraProperties.qcoMock_mockPopover2
    }
    #endif
    /*
     #if TARGET_OS_IOS
- (UIPopoverPresentationController *)qcoMock_popoverPresentationController
{
    if ([self respondsToSelector:@selector(qcoMock_mockPopover)]) {
        return (id)self.qcoMock_mockPopover;
    }
    return nil;
}
     */
}

class UIAlertControllerExtraProperties: NSObject {
    static let associatedObjectKey = "extraProperties"

    let preferredStyle: UIAlertController.Style
    #if os(iOS)
        var qcoMock_mockPopover2: QCOMockPopoverPresentationController?
        var mockPopover: UIPopoverPresentationController?
    #endif

    /*
     #if TARGET_OS_IOS
@property (nonatomic, strong) QCOMockPopoverPresentationController *qcoMock_mockPopover;
#endif

     */
    init(preferredStyle: UIAlertController.Style, alertController: UIAlertController) {
        self.preferredStyle = preferredStyle
        mockPopover = UIPopoverPresentationController(presentedViewController2: alertController, presenting: nil)
        super.init()
    }
}

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
}
