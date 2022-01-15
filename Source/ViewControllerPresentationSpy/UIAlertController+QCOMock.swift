import UIKit

extension UIAlertController {
    
@objc class func qcoMock2_swizzle() {
    UIAlertController.qcoMock_swizzle()

//    NSObject.qcoMockAlerts_replaceClassMet
//    [self qcoMockAlerts_replaceClassMethod:@selector(alertControllerWithTitle:message:preferredStyle:)
//    withMethod:@selector(qcoMock_alertControllerWithTitle:message:preferredStyle:)];
}

}
