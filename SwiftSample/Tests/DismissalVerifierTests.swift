//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import XCTest

final class DismissalVerifierTests: XCTestCase {
    private var sut: DismissalVerifier!
    private var vc: StoryboardNextViewController!

    override func setUp() {
        super.setUp()
        sut = DismissalVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: String(describing: StoryboardNextViewController.self)) as? StoryboardNextViewController
        vc.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }

    private func dismissViewController() {
        tap(vc.cancelButton)
    }

    func test_dismissingVC_shouldCaptureAnimationFlag() {
        dismissViewController()

        XCTAssertTrue(sut.animated)
    }

    func test_dismissingVC_shouldCaptureDismissedViewController() {
        dismissViewController()

        XCTAssertTrue(sut.dismissedViewController === vc,
                "Expected dismissed view controller to be \(String(describing: vc))), but was \(String(describing: sut.dismissedViewController)))")
    }

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

    func test_dismissingVC_withoutCompletion_shouldNotCaptureCompletionBlock() {
        dismissViewController()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_dismissingVC_shouldExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        dismissViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notDismissingVC_shouldNotExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}
