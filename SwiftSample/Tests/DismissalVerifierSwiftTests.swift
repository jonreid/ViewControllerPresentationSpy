// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import FailKit
import ViewControllerPresentationSpy
import Testing
import UIKit

@MainActor
final class DismissalVerifierSwiftTests: @unchecked Sendable {
    private let vc: StoryboardNextViewController

    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: String(describing: StoryboardNextViewController.self))
        vc.loadViewIfNeeded()
    }

    private func dismissViewController() {
        tap(vc.cancelButton)
    }

    @Test("dismissing VC captures animation flag")
    func dismissingVC_capturesAnimationFlag() throws {
        let sut = DismissalVerifier()

        dismissViewController()

        #expect(sut.animated)
    }

    @Test("dismissing VC captures dismissed view controller")
    func dismissingVC_capturesDismissedViewController() throws {
        let sut = DismissalVerifier()
        
        dismissViewController()

        #expect(sut.dismissedViewController === vc, """
            Expected dismissed view controller to be \(String(describing: vc))),
            but was \(String(describing: sut.dismissedViewController)))
            """)
    }

    @Test("dismissing VC with completion captures completion")
    func dismissingVC_withCompletion_capturesCompletion() throws {
        let sut = DismissalVerifier()
        var completionCallCount = 0
        vc.viewControllerDismissedCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        #expect(completionCallCount == 0, "precondition")
        sut.capturedCompletion?()
        #expect(completionCallCount == 1)
    }

    @Test("dismissing VC without completion does not capture completion")
    func dismissingVC_withoutCompletion_doesNotCaptureCompletion() throws {
        let sut = DismissalVerifier()

        dismissViewController()

        #expect(sut.capturedCompletion == nil)
    }

    @Test("dismissing VC executes completion")
    func dismissingVC_executesCompletion() throws {
        let sut = DismissalVerifier()
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        #expect(completionCallCount == 1)
    }

    @Test("not dismissing VC does not execute completion")
    func notDismissingVC_doesNotExecuteCompletion() throws {
        let sut = DismissalVerifier()
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        #expect(completionCallCount == 0)
    }

    @Test("not dismissed")
    func notDismissed() throws {
        let sut = DismissalVerifier()
        let failSpy = FailSpy()

        sut.verify(animated: true, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        #expect(failSpy.messages.first == "dismiss not called")
    }

    @Test("dismissed twice")
    func dismissedTwice() throws {
        let sut = DismissalVerifier()
        let failSpy = FailSpy()
        dismissViewController()
        dismissViewController()

        sut.verify(animated: true, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        #expect(failSpy.messages.first == "dismiss called 2 times, expected once")
    }

    @Test("wrong animated flag")
    func wrongAnimatedFlag() throws {
        let sut = DismissalVerifier()
        let failSpy = FailSpy()
        dismissViewController()

        sut.verify(animated: false, failure: failSpy)

        #expect(failSpy.callCount == 1, "call count")
        #expect(failSpy.messages.first == "Expected non-animated dismiss, but was animated")
    }
}

@MainActor
private func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
} 
