import UIKit

extension UIAlertController {

    @objc class func qcoMock_swizzle() {
        UIAlertController.qcoMockAlerts_replaceClassMethod(
                #selector(UIAlertController.init(title:message:preferredStyle:)),
                withMethod: #selector(UIAlertController.qcoMock_alertController(withTitle:message:preferredStyle:))
        )

        #if (os(iOS))
            UIAlertController.qcoMockAlerts_replaceInstanceMethod(
                    #selector(getter: UIAlertController.popoverPresentationController),
                    withMethod: #selector(UIAlertController.qcoMock_popoverPresentationController)
            )
        #endif
    }
    
    @objc class func qcoMock_alertController2(title: String, message: String, preferredStyle: UIAlertController.Style) {
        
    } 
    
    /*
+ (instancetype)qcoMock_alertControllerWithTitle:(NSString *)title
                                    message:(NSString *)message
                             preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    return [[self alloc] initQCOMockWithTitle:title message:message preferredStyle:preferredStyle];
}
     */
}
