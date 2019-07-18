@testable import MockUIAlertControllerSampleSwift
import XCTest

final class ViewControllerPresentationTests: XCTestCase {
    private var presentationVerifier: QCOMockPresentationVerifier!
    private var sut: ViewController!

    override func setUp() {
        super.setUp()
        presentationVerifier = QCOMockPresentationVerifier()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController() as? ViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        presentationVerifier = nil
        sut = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.showModalButton)
    }

    func test_tappingShowModalButton_shouldShowAlert() {
        sut.showModalButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presentationVerifier.presentedCount, 1, "presented count")
        XCTAssertTrue(presentationVerifier.animated, "animated")
        XCTAssertTrue(presentationVerifier.presentingViewController === sut,
                "Expected presenting view controller to be \(String(describing: sut)), but was \(presentationVerifier.presentingViewController)")
        guard let nextVC = presentationVerifier.presentedViewController as? CodeNextViewController else {
            XCTFail("Expected presented view controller to be \(String(describing: CodeNextViewController.self)), but was \(presentationVerifier.presentedViewController)")
            return
        }
        XCTAssertEqual(nextVC.backgroundColor, UIColor.purple, "Background color passed in")
    }
}
