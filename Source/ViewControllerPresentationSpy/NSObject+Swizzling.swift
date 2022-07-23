import Foundation

extension NSObject {
    static func replaceClassMethod(original: Selector, swizzled: Selector) {
        guard let originalMethod = class_getClassMethod(self, original),
              let swizzledMethod = class_getClassMethod(self, swizzled)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func replaceInstanceMethod(original: Selector, swizzled: Selector) {
        guard let originalMethod = class_getInstanceMethod(self, original),
              let swizzledMethod = class_getInstanceMethod(self, swizzled)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
