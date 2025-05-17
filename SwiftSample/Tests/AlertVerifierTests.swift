// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
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

    func test_tappingShowAlertButton_shouldShowAlert() {
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
        XCTAssertEqual(failSpy.messages.first, "Expected Optional(\"TITLE\"), but was Optional(\"Title\") - alert title")
        XCTAssertEqual(failSpy.messages.last, "Expected Optional(\"MESSAGE\"), but was Optional(\"Message\") - alert message")
    }


    func test_executeActionForButtonWithTitle_withNonexistentTitle_shouldThrowException() {
        showAlert()

        XCTAssertThrowsError(try sut.executeAction(forButton: "NO SUCH BUTTON"))
    }

    func test_executeActionForButtonWithTitle_withoutHandler_shouldNotCrash() throws {
        showAlert()

        try sut.executeAction(forButton: "No Handler")
    }

    func test_showingAlert_withCompletion_shouldCaptureCompletionBlock() {
        var completionCallCount = 0
        vc.alertPresentedCompletion = {
            completionCallCount += 1
        }
        showAlert()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_showingAlert_withoutCompletion_shouldNotCaptureCompletionBlock() {
        showAlert()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_showingAlert_shouldExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        showAlert()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notShowingAlert_shouldNotExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}

final class FailSpy: Failing {
    private(set) var callCount = 0
    private(set) var messages: [String] = []
    private(set) var locations: [SourceLocation] = []

    func fail(message: String, location: SourceLocation) {
        callCount += 1
        self.messages.append(message)
        self.locations.append(location)
    }
}
