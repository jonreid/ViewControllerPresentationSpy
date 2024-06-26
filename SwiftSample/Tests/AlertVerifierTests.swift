// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import ViewControllerPresentationSpy
@testable import SwiftSampleViewControllerPresentationSpy
import XCTest

final class AlertVerifierTests: XCTestCase {
    private var sut: AlertVerifier!
    private var vc: ViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        sut = AlertVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        vc.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }

    @MainActor
    private func showAlert() {
        vc.showAlertButton.sendActions(for: .touchUpInside)
    }

    @MainActor
    func test_executeActionForButtonWithTitle_withNonexistentTitle_shouldThrowException() {
        showAlert()

        XCTAssertThrowsError(try sut.executeAction(forButton: "NO SUCH BUTTON"))
    }

    @MainActor
    func test_executeActionForButtonWithTitle_withoutHandler_shouldNotCrash() throws {
        showAlert()

        try sut.executeAction(forButton: "No Handler")
    }

    @MainActor
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

    @MainActor
    func test_showingAlert_withoutCompletion_shouldNotCaptureCompletionBlock() {
        showAlert()

        XCTAssertNil(sut.capturedCompletion)
    }

    @MainActor
    func test_showingAlert_shouldExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        showAlert()

        XCTAssertEqual(completionCallCount, 1)
    }

    @MainActor
    func test_notShowingAlert_shouldNotExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}
