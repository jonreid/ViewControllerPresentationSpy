import UIKit

extension UIAlertController {

    @objc class func qcoMock_swizzle() {
        UIAlertController.qcoMockAlerts_replaceClassMethod(
                #selector(UIAlertController.init(title:message:preferredStyle:)),
                withMethod: #selector(UIAlertController.qcoMock_alertController(title:message:preferredStyle:))
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
        UIAlertController.init(qcoMockWithTitle: title, message: message, preferredStyle: preferredStyle)
    }
    
    @objc convenience init(qcoMockWithTitle2 title: String, message: String, preferredStyle style: UIAlertController.Style) {
        self.init()
        self.title = title
        self.message = message
//        self.preferredStyle = style

        let extraProperties = UIAlertControllerExtraProperties(preferredStyle: style)
        objc_setAssociatedObject(
                self,
                "extraProperties",
                extraProperties,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        // mockPopover
    }
    
    /*
- (instancetype)initQCOMockWithTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)style
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.preferredStyle = style;
#if TARGET_OS_IOS
        self.qcoMock_mockPopover = [[QCOMockPopoverPresentationController alloc] init];
#endif
    }
    return self;
}
     */
}

class UIAlertControllerExtraProperties: NSObject {
    let preferredStyle: UIAlertController.Style

    init(preferredStyle: UIAlertController.Style) {
        self.preferredStyle = preferredStyle 
        super.init()
    }
}
