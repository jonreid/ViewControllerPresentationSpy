// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import FailKit
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class AlertVerifierTests: XCTestCase, Sendable {
    private var sut: AlertVerifier!
    private var vc: ViewController!

    override func setUp() async throws {
        try await super.setUp()
        sut = AlertVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        vc.loadViewIfNeeded()
    }

    override func tearDown() async throws {
        sut = nil
        vc = nil
        try await super.tearDown()
    }

    private func showAlert() {
        vc.showAlertButton.sendActions(for: .touchUpInside)
    }

    func test_wrongTitleAndMessage() throws {
        let failSpy = FailSpy()
        showAlert()

        sut.verify(
            title: "TITLE",
            message: "MESSAGE",
            animated: true,
            actions: [
                .default("No Handler"),
                .default("Default"),
                .cancel("Cancel"),
                .destructive("Destroy"),
            ],
            failure: failSpy
        )

        XCTAssertEqual(failSpy.callCount, 2, "call count")
        XCTAssertEqual(
            failSpy.messages.first,
            "Expected Optional(\"TITLE\"), but was Optional(\"Title\") - alert title"
        )
        XCTAssertEqual(
            failSpy.messages.last,
            "Expected Optional(\"MESSAGE\"), but was Optional(\"Message\") - alert message"
        )
    }

    func test_wrongPresentingViewController() throws {
        let failSpy = FailSpy()
        showAlert()

        sut.verify(
            title: "Title",
            message: "Message",
            animated: true,
            actions: [
                .default("No Handler"),
                .default("Default"),
                .cancel("Cancel"),
                .destructive("Destroy"),
            ],
            presentingViewController: UIViewController(),
            failure: failSpy
        )

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        let message = try XCTUnwrap(failSpy.messages.first)
        verify(message, hasPrefix: "Expected same instance as <UIViewController: ")
        verify(message, contains: ">, but was <SwiftSampleViewControllerPresentationSpy.ViewController: ")
        verify(message, hasSuffix: "> - presenting view controller")
    }

    func verify(_ actual: String, hasPrefix prefix: String, file: StaticString = #filePath, line: UInt = #line) {
        if actual.hasPrefix(prefix) { return }
        XCTFail("Expected string starting with \"\(prefix)\", but was \"\(actual)\"", file: file, line: line)
    }

    func verify(_ actual: String, hasSuffix suffix: String, file: StaticString = #filePath, line: UInt = #line) {
        if actual.hasSuffix(suffix) { return }
        XCTFail("Expected string ending with \"\(suffix)\", but was \"\(actual)\"", file: file, line: line)
    }

    func verify(_ actual: String, contains substring: String, file: StaticString = #filePath, line: UInt = #line) {
        if actual.contains(substring) { return }
        XCTFail("Expected string containing \"\(substring)\", but was \"\(actual)\"", file: file, line: line)
    }

    func test_executeActionForButtonWithTitle_withNonexistentTitle_throwsException() throws {
        showAlert()

        XCTAssertThrowsError(try sut.executeAction(forButton: "NO SUCH BUTTON"))
    }

    func test_executeActionForButtonWithTitle_withoutHandler_shouldNotCrash() throws {
        showAlert()

        try sut.executeAction(forButton: "No Handler")
    }

    func test_showingAlert_withCompletion_capturesCompletion() throws {
        var completionCallCount = 0
        vc.alertPresentedCompletion = {
            completionCallCount += 1
        }

        showAlert()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_showingAlert_withoutCompletion_doesNotCaptureCompletion() throws {
        showAlert()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_showingAlert_executesCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        showAlert()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notShowingAlert_doesNotExecuteCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }

    func test_notShown() throws {
        let failSpy = FailSpy()

        sut.verify(
            title: "TITLE",
            message: "MESSAGE",
            animated: true,
            actions: [
                .default("No Handler"),
                .default("Default"),
                .cancel("Cancel"),
                .destructive("Destroy"),
            ],
            failure: failSpy
        )

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "present not called")
    }

    func test_shownTwice() throws {
        let failSpy = FailSpy()
        showAlert()
        showAlert()

        sut.verify(
            title: "Title",
            message: "Message",
            animated: true,
            actions: [
                .default("No Handler"),
                .default("Default"),
                .cancel("Cancel"),
                .destructive("Destroy"),
            ],
            failure: failSpy
        )

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "present called 2 times, expected once")
    }

    func test_wrongAnimatedFlag() throws {
        let failSpy = FailSpy()
        showAlert()

        sut.verify(
            title: "Title",
            message: "Message",
            animated: false,
            actions: [
                .default("No Handler"),
                .default("Default"),
                .cancel("Cancel"),
                .destructive("Destroy"),
            ],
            failure: failSpy
        )

        XCTAssertEqual(failSpy.callCount, 1, "call count")
        XCTAssertEqual(failSpy.messages.first, "Expected non-animated present, but was animated")
    }
}
