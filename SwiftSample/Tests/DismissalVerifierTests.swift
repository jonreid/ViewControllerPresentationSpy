// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import XCTest

final class DismissalVerifierTests: XCTestCase {
    private var sut: DismissalVerifier!
    private var vc: StoryboardNextViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        sut = DismissalVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: StoryboardNextViewController.self))
        vc.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }

    @MainActor
    private func dismissViewController() {
        tap(vc.cancelButton)
    }

    @MainActor
    func test_dismissingVC_shouldCaptureAnimationFlag() {
        dismissViewController()

        XCTAssertTrue(sut.animated)
    }

    @MainActor
    func test_dismissingVC_shouldCaptureDismissedViewController() {
        dismissViewController()

        XCTAssertTrue(
            sut.dismissedViewController === vc,
            """
            Expected dismissed view controller to be \(String(describing: vc))),
            but was \(String(describing: sut.dismissedViewController)))
            """
        )
    }

    @MainActor
    func test_dismissingVC_withCompletion_shouldCaptureCompletionBlock() {
        var completionCallCount = 0
        vc.viewControllerDismissedCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    @MainActor
    func test_dismissingVC_withoutCompletion_shouldNotCaptureCompletionBlock() {
        dismissViewController()

        XCTAssertNil(sut.capturedCompletion)
    }

    @MainActor
    func test_dismissingVC_shouldExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    @MainActor
    func test_notDismissingVC_shouldNotExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}

@MainActor
func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}
