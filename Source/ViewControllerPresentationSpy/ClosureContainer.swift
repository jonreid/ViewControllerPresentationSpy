//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

import Foundation

@objc(QCOClosureContainer)
public class ClosureContainer: NSObject {
    let closure: (() -> Void)?

    @objc public init(closure: (() -> Void)?) {
        self.closure = closure
        super.init()
    }
}
