// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import ViewControllerPresentationSpy
@testable import SwiftSampleViewControllerPresentationSpy
import XCTest

@MainActor
final class PresentationVerifierTests: XCTestCase {
    private var sut: PresentationVerifier!
    private var vc: ViewController!

    override func setUp() {
        super.setUp()
        sut = PresentationVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        vc.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }

    private func presentViewController() {
        vc.codePresentModalButton.sendActions(for: .touchUpInside)
    }

    func test_presentingVC_withCompletion_shouldCaptureCompletionBlock() {
        var completionCallCount = 0
        vc.viewControllerPresentedCompletion = {
            completionCallCount += 1
        }
        presentViewController()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_presentingVC_withoutCompletion_shouldNotCaptureCompletionBlock() {
        presentViewController()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_presentingVC_shouldExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        presentViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notPresentingVC_shouldNotExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}
