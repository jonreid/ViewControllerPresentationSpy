import UIKit

extension UIAlertAction {
    @objc class func qcoMock_swizzle2() {
        UIAlertAction.qcoMockAlerts_replaceClassMethod(
                #selector(UIAlertAction.init(title:style:handler:)),
                withMethod: #selector(UIAlertAction.qcoMock_action(withTitle:style:handler:))
        )
    }
}
