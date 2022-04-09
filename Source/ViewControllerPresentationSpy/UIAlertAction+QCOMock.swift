import UIKit

extension UIAlertAction {
    @objc class func qcoMock_swizzle2() {
        UIAlertAction.qcoMock_swizzle()
//        UIAlertAction.qcoMockAlerts_replaceClassMethod(
//                #selector(UIAlertAction.init(title:style:handler:)),
//                withMethod: #selector(UIAlertAction.qcoMock_action(withTitle:style:handler:))
//        )
    }
}
