// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import FailKit
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class PresentationVerifierTests: XCTestCase, Sendable {
    private var sut: PresentationVerifier!
    private var vc: ViewController!

    override func setUp() async throws {
        try await super.setUp()
        sut = PresentationVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        vc.loadViewIfNeeded()
    }

    override func tearDown() async throws {
        sut = nil
        vc = nil
        try await super.tearDown()
    }

    private func presentViewController() {
        vc.codePresentModalButton.sendActions(for: .touchUpInside)
    }

    func test_presentingVC_withCompletion_capturesCompletion() throws {
        var completionCallCount = 0
        vc.viewControllerPresentedCompletion = {
            completionCallCount += 1
        }
        presentViewController()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_presentingVC_withoutCompletion_doesNotCaptureCompletion() throws {
        presentViewController()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_presentingVC_executesCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        presentViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notPresentingVC_doesNotExecuteCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }

    func test_notCalled() throws {
        let failSpy = FailSpy()

        sut.verify(animated: true, presentingViewController: vc, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "present not called")
    }

    func test_calledTwice() throws {
        let failSpy = FailSpy()
        presentViewController()
        presentViewController()

        sut.verify(animated: true, presentingViewController: vc, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "present called 2 times, expected once")
    }

    func test_wrongAnimatedFlag() throws {
        let failSpy = FailSpy()
        presentViewController()

        sut.verify(animated: false, presentingViewController: vc, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "Expected non-animated present, but was animated")
    }

    func test_wrongTypeOfViewController() throws {
        let failSpy = FailSpy()
        presentViewController()

        let _: StoryboardNextViewController? = sut.verify(animated: true, failure: failSpy)

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        let message = try XCTUnwrap(failSpy.messages.first)
        let expectedPrefix = "Expected StoryboardNextViewController, but was Optional(<SwiftSampleViewControllerPresentationSpy.CodeNextViewController: "
        XCTAssertTrue(message.hasPrefix(expectedPrefix), "Expected prefix '\(expectedPrefix)', but was \(message)")
    }
}
