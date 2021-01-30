//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

import ViewControllerPresentationSpy
@testable import SwiftSampleViewControllerPresentationSpy
import XCTest

final class AlertVerifierTests: XCTestCase {
    private var sut: AlertVerifier!
    private var vc: ViewController!

    override func setUp() {
        super.setUp()
        sut = AlertVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController
        vc.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }
    
    private func showAlert() {
        vc.showAlertButton.sendActions(for: .touchUpInside)
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
