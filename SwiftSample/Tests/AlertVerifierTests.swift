@testable import ViewControllerPresentationSpy
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

    func test_showingAlert_shouldExecuteCompletionBlock() {
        var completionCallCount = 0
        sut.completion = {
            completionCallCount += 1
        }
        
        showAlert()
        
        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notShowingAlert_shouldNotExecuteCompletionBlock() {
        var completionCallCount = 0
        sut.completion = {
            completionCallCount += 1
        }
        
        XCTAssertEqual(completionCallCount, 0)
    }
}
