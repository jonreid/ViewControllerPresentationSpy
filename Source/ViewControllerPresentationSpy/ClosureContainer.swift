import Foundation

@objc(QCOClosureContainer)
public class ClosureContainer: NSObject {
    let closure: (() -> Void)?

    @objc public init(closure: (() -> Void)?) {
        self.closure = closure
        super.init()
    }
}
