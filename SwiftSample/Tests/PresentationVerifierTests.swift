//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

import ViewControllerPresentationSpy
@testable import SwiftSampleViewControllerPresentationSpy
import XCTest

final class PresentationVerifierTests: XCTestCase {
    private var sut: PresentationVerifier!
    private var vc: ViewController!

    override func setUp() {
        super.setUp()
        sut = PresentationVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController
        vc.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }

    private func presentViewController() {
        vc.codePresentModalButton.sendActions(for: .touchUpInside)
    }

    func test_presentingVC_withCompletion_shouldCaptureCompletionBlock() {
        var completionCallCount = 0
        vc.viewControllerPresentedCompletion = {
            completionCallCount += 1
        }
        presentViewController()

        XCTAssertEqual(completionCallCount, 0, "precondition")
        sut.capturedCompletion?()
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_presentingVC_withoutCompletion_shouldNotCaptureCompletionBlock() {
        presentViewController()

        XCTAssertNil(sut.capturedCompletion)
    }

    func test_presentingVC_shouldExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        presentViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notPresentingVC_shouldNotExecuteTestCompletionBlock() {
        var completionCallCount = 0
        sut.testCompletion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}
