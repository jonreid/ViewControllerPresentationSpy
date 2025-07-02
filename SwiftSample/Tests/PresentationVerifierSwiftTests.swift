// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import FailKit
import ViewControllerPresentationSpy
import Testing
import UIKit

@MainActor
final class PresentationVerifierSwiftTests: @unchecked Sendable {
    private let vc: ViewController

    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        vc.loadViewIfNeeded()
    }

    private func presentViewController() {
        vc.codePresentModalButton.sendActions(for: .touchUpInside)
    }

    @Test("presenting VC with completion captures completion")
    func presentingVC_withCompletion_capturesCompletion() throws {
        let sut = PresentationVerifier()
        var completionCallCount = 0
        vc.viewControllerPresentedCompletion = {
            completionCallCount += 1
        }

        presentViewController()

        #expect(completionCallCount == 0, "precondition")
        sut.capturedCompletion?()
        #expect(completionCallCount == 1)
    }

    @Test("presenting VC without completion does not capture completion")
    func presentingVC_withoutCompletion_doesNotCaptureCompletion() throws {
        let sut = PresentationVerifier()

        presentViewController()

        #expect(sut.capturedCompletion == nil)
    }

    @Test("presenting VC executes completion")
    func presentingVC_executesCompletion() throws {
        let sut = PresentationVerifier()
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        presentViewController()

        #expect(completionCallCount == 1)
    }

    @Test("not presenting VC does not execute completion")
    func notPresentingVC_doesNotExecuteCompletion() throws {
        let sut = PresentationVerifier()
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        #expect(completionCallCount == 0)
    }

    @Test("not called")
    func notCalled() throws {
        let sut = PresentationVerifier()
        let failSpy = FailSpy()

        sut.verify(animated: true, presentingViewController: vc, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        #expect(failSpy.messages.first == "present not called")
    }

    @Test("called twice")
    func calledTwice() throws {
        let sut = PresentationVerifier()
        let failSpy = FailSpy()
        presentViewController()
        presentViewController()

        sut.verify(animated: true, presentingViewController: vc, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        #expect(failSpy.messages.first == "present called 2 times, expected once")
    }

    @Test("wrong animated flag")
    func wrongAnimatedFlag() throws {
        let sut = PresentationVerifier()
        let failSpy = FailSpy()
        presentViewController()

        sut.verify(animated: false, presentingViewController: vc, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        #expect(failSpy.messages.first == "Expected non-animated present, but was animated")
    }

    @Test("wrong type of view controller")
    func wrongTypeOfViewController() throws {
        let sut = PresentationVerifier()
        let failSpy = FailSpy()
        presentViewController()

        let _: StoryboardNextViewController? = sut.verify(animated: true, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        let message = try #require(failSpy.messages.first)
        let expectedPrefix = "Expected StoryboardNextViewController, but was Optional(<SwiftSampleViewControllerPresentationSpy.CodeNextViewController: "
        verify(message, hasPrefix: expectedPrefix, message: "Expected prefix '\(expectedPrefix)', but was \(message)")
    }

    private func verify(
        _ actual: String,
        hasPrefix prefix: String,
        message: String,
        fileID: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
    ) {
        if actual.hasPrefix(prefix) { return }
        Issue.record(
            "\(message)",
            sourceLocation: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
        )
    }
} 
