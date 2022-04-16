//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2022 Jonathan M. Reid. See LICENSE.txt

import UIKit

extension UIAlertAction {
    @objc class func qcoMock_swizzle() {
        UIAlertAction.qcoMockAlerts_replaceClassMethod(
                #selector(UIAlertAction.init(title:style:handler:)),
                withMethod: #selector(UIAlertAction.qcoMock_action(withTitle:style:handler:))
        )
    }

//+ (instancetype)qcoMock_actionWithTitle:(NSString *)title
//        style:(UIAlertActionStyle)style
//        handler:(void (^ __nullable)(UIAlertAction *action))handler
//{
//        UIAlertAction *action = [self qcoMock_actionWithTitle:title style:style handler:handler];
//        objc_setAssociatedObject(action, @selector(qcoMock_handler), handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
//return action;
//}

    @objc class func qcoMock_action2(withTitle title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let action = UIAlertAction.qcoMock_action2(withTitle: title, style: style, handler: handler)
        objc_setAssociatedObject(action, foo, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return action
    }
}
