// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import FailKit
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class DismissalVerifierTests: XCTestCase, Sendable {
    private var sut: DismissalVerifier!
    private var vc: StoryboardNextViewController!

    override func setUp() async throws {
        try await super.setUp()
        sut = DismissalVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: StoryboardNextViewController.self))
        vc.loadViewIfNeeded()
    }

    override func tearDown() async throws {
        sut = nil
        vc = nil
        try await super.tearDown()
    }

    private func dismissViewController() {
        tap(vc.cancelButton)
    }

    func test_dismissingVC_capturesAnimationFlag() throws {
        dismissViewController()

        XCTAssertTrue(sut.animated)
    }

    func test_dismissingVC_capturesDismissedViewController() throws {
        dismissViewController()

        XCTAssertTrue(
            sut.dismissedViewController === vc,
            """
            Expected dismissed view controller to be \(String(describing: vc))),
            but was \(String(describing: sut.dismissedViewController)))
            """
        )
    }

    func test_dismissingVC_withCompletion_capturesCompletion() throws {
        var completionCallCount = 0
        vc.viewControllerDismissedCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_dismissingVC_withoutCompletion_doesNotCaptureCompletion() throws {
        dismissViewController()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_dismissingVC_executesCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notDismissingVC_doesNotExecuteCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }

    func test_notDismissed() throws {
        let failSpy = FailSpy()

        sut.verify(animated: true, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "dismiss not called")
    }

    func test_dismissedTwice() throws {
        let failSpy = FailSpy()
        dismissViewController()
        dismissViewController()

        sut.verify(animated: true, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "dismiss called 2 times, expected once")
    }

    func test_wrongAnimatedFlag() throws {
        let failSpy = FailSpy()
        dismissViewController()

        sut.verify(animated: false, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "Expected non-animated dismiss, but was animated")
    }
}

@MainActor
private func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}
