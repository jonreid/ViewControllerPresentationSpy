import Foundation

extension NSObject {
    static func qcoMockAlerts_replaceClassMethod2(_ originalSelector: Selector,
                                                  _ swizzledSelector: Selector)
    {
        guard let originalMethod = class_getClassMethod(self, originalSelector),
              let swizzledMethod = class_getClassMethod(self, swizzledSelector)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
