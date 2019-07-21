@testable import ViewControllerPresentationSpy
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

    func test_presentingVC_shouldExecuteCompletionBlock() {
        var completionCallCount = 0
        sut.completion = {
            completionCallCount += 1
        }

        presentViewController()

        XCTAssertEqual(completionCallCount, 1)
    }

    func test_notPresentingVC_shouldNotExecuteCompletionBlock() {
        var completionCallCount = 0
        sut.completion = {
            completionCallCount += 1
        }

        XCTAssertEqual(completionCallCount, 0)
    }
}
