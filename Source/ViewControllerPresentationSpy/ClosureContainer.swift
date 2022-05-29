// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import Foundation

@objc(QCOClosureContainer)
public class ClosureContainer: NSObject {
    let closure: (() -> Void)?

    @objc public init(closure: (() -> Void)?) {
        self.closure = closure
        super.init()
    }
}
