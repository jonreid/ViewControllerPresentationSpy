// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import Foundation

class ClosureContainer: NSObject {
    let closure: (() -> Void)?

    @objc init(closure: (() -> Void)?) {
        self.closure = closure
        super.init()
    }
}
