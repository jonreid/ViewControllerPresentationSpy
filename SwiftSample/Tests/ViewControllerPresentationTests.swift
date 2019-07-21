@testable import SwiftSampleViewControllerPresentationSpy
import XCTest

final class ViewControllerPresentationTests: XCTestCase {
    private var presentationVerifier: PresentationVerifier!
    private var sut: ViewController!

    override func setUp() {
        super.setUp()
        presentationVerifier = PresentationVerifier()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        RunLoop.current.run(until: Date()) // Free objects after segue show
        presentationVerifier = nil
        sut = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.seguePresentModalButton)
        XCTAssertNotNil(sut.segueShowButton)
        XCTAssertNotNil(sut.codePresentModalButton)
    }

    func test_tappingSeguePresentModalButton_shouldPresentNextViewControllerWithGreenBackground() {
        sut.seguePresentModalButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presentationVerifier.presentedCount, 1, "presented count")
        XCTAssertTrue(presentationVerifier.animated, "animated")
        XCTAssertTrue(presentationVerifier.presentingViewController === sut,
                """
                Expected presenting view controller to be \(String(describing: sut)), \
                but was \(String(describing: presentationVerifier.presentingViewController))
                """)
        guard let nextVC = presentationVerifier.presentedViewController as? StoryboardNextViewController else {
            XCTFail("""
                    Expected presented view controller to be \(String(describing: StoryboardNextViewController.self)), \
                    but was \(String(describing: presentationVerifier.presentedViewController))
                    """)
            return
        }
        XCTAssertEqual(nextVC.backgroundColor, UIColor.green, "Background color passed in")
    }

    func test_tappingSegueShowButton_shouldShowNextViewControllerWithGreenBackground() {
        let window = UIWindow()
        window.rootViewController = sut
        window.isHidden = false
        
        sut.segueShowButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presentationVerifier.presentedCount, 1, "presented count")
        XCTAssertTrue(presentationVerifier.animated, "animated")
        XCTAssertTrue(presentationVerifier.presentingViewController === sut,
                """
                Expected presenting view controller to be \(String(describing: sut)), \
                but was \(String(describing: presentationVerifier.presentingViewController))
                """)
        guard let nextVC = presentationVerifier.presentedViewController as? StoryboardNextViewController else {
            XCTFail("""
                    Expected presented view controller to be \(String(describing: StoryboardNextViewController.self)), \
                    but was \(String(describing: presentationVerifier.presentedViewController))
                    """)
            return
        }
        XCTAssertEqual(nextVC.backgroundColor, UIColor.red, "Background color passed in")
    }

    func test_tappingCodeModalButton_shouldPresentNextViewControllerWithPurpleBackground() {
        sut.codePresentModalButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presentationVerifier.presentedCount, 1, "presented count")
        XCTAssertTrue(presentationVerifier.animated, "animated")
        XCTAssertTrue(presentationVerifier.presentingViewController === sut,
                """
                Expected presenting view controller to be \(String(describing: sut)), \
                but was \(String(describing: presentationVerifier.presentingViewController))
                """)
        guard let nextVC = presentationVerifier.presentedViewController as? CodeNextViewController else {
            XCTFail("""
                    Expected presented view controller to be \(String(describing: CodeNextViewController.self)), \
                    but was \(String(describing: presentationVerifier.presentedViewController))
                    """)
            return
        }
        XCTAssertEqual(nextVC.backgroundColor, UIColor.purple, "Background color passed in")
    }
}
