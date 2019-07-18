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
}
