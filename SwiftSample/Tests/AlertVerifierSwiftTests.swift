// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import FailKit
import ViewControllerPresentationSpy
import Testing
import UIKit

@MainActor
@Suite(.serialized)
final class AlertVerifierSwiftTests: @unchecked Sendable {
    private let sut = AlertVerifier()
    private let vc: ViewController

    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        vc.loadViewIfNeeded()
    }

    private func showAlert() {
        vc.showAlertButton.sendActions(for: .touchUpInside)
    }

    @Test("wrong title and message")
    func wrongTitleAndMessage() throws {
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

        #expect(failSpy.callCount == 2)
        #expect(failSpy.messages.first == "Expected Optional(\"TITLE\"), but was Optional(\"Title\") - alert title")
        #expect(failSpy.messages.last == "Expected Optional(\"MESSAGE\"), but was Optional(\"Message\") - alert message")
    }

    @Test("wrong presenting view controller")
    func wrongPresentingViewController() throws {
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

        #expect(failSpy.callCount == 1)
        let message = try #require(failSpy.messages.first)
        verify(message, hasPrefix: "Expected same instance as <UIViewController: ")
        verify(message, contains: ">, but was <SwiftSampleViewControllerPresentationSpy.ViewController: ")
        verify(message, hasSuffix: "> - presenting view controller")
    }

    private func verify(
        _ actual: String,
        hasPrefix prefix: String,
        fileID: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
    ) {
        if actual.hasPrefix(prefix) { return }
        Issue.record(
            "Expected string starting with \"\(prefix)\", but was \"\(actual)\"",
            sourceLocation: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
    }
    private func verify(
        _ actual: String,
        hasSuffix suffix: String,
        fileID: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
    ) {
        if actual.hasSuffix(suffix) { return }
        Issue.record(
            "Expected string ending with \"\(suffix)\", but was \"\(actual)\"",
            sourceLocation: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
    }
    private func verify(
        _ actual: String,
        contains substring: String,
        fileID: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
    ) {
        if actual.contains(substring) { return }
        Issue.record(
            "Expected string containing \"\(substring)\", but was \"\(actual)\"",
            sourceLocation: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
    }

    @Test("execute action for button with title with nonexistent title throws exception")
    func executeActionForButtonWithTitle_withNonexistentTitle_throwsException() throws {
        showAlert()

        #expect(throws: (any Error).self) {
            try self.sut.executeAction(forButton: "NO SUCH BUTTON")
        }
    }

    @Test("execute action for button with title without handler should not crash")
    func executeActionForButtonWithTitle_withoutHandler_shouldNotCrash() throws {
        showAlert()

        try sut.executeAction(forButton: "No Handler")
    }

    @Test("showing alert with completion captures completion")
    func showingAlert_withCompletion_capturesCompletion() throws {
        var completionCallCount = 0
        vc.alertPresentedCompletion = {
            completionCallCount += 1
        }

        showAlert()

        #expect(completionCallCount == 0)
        sut.capturedCompletion?()
        #expect(completionCallCount == 1)
    }

    @Test("showing alert without completion does not capture completion")
    func showingAlert_withoutCompletion_doesNotCaptureCompletion() throws {
        showAlert()

        #expect(sut.capturedCompletion == nil)
    }

    @Test("showing alert executes completion")
    func showingAlert_executesCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        showAlert()

        #expect(completionCallCount == 1)
    }

    @Test("not showing alert does not execute completion")
    func notShowingAlert_doesNotExecuteCompletion() throws {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        #expect(completionCallCount == 0)
    }

    @Test("not shown")
    func notShown() throws {
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

        #expect(failSpy.callCount == 1)
        #expect(failSpy.messages.first == "present not called")
    }

    @Test("shown twice")
    func shownTwice() throws {
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

        #expect(failSpy.callCount == 1)
        #expect(failSpy.messages.first == "present called 2 times, expected once")
    }

    @Test("wrong animated flag")
    func wrongAnimatedFlag() throws {
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

        #expect(failSpy.callCount == 1)
        #expect(failSpy.messages.first == "Expected non-animated present, but was animated")
    }
}
