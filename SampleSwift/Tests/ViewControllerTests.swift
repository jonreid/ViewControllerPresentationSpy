@testable import MockUIAlertControllerSampleSwift
import XCTest

final class ViewControllerTests: XCTestCase {
    private var alertVerifier: QCOMockAlertVerifier!
    private var sut: ViewController!

    override func setUp() {
        super.setUp()
        alertVerifier = QCOMockAlertVerifier()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = (storyboard.instantiateInitialViewController() as! ViewController)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        alertVerifier = nil
        sut = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.showAlertButton)
        XCTAssertNotNil(sut.showActionSheetButton)
    }

    func test_tappingShowAlertButton_shouldShowAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1, "presented count")
        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertController.Style.alert, "preferred style")
        XCTAssertTrue(alertVerifier.presentingViewController === sut,
                "Expected presenting view controller to be \(String(describing: sut)), but was \(alertVerifier.presentingViewController)")
        XCTAssertTrue(alertVerifier.animated, "animated")
        XCTAssertEqual(alertVerifier.title, "Title", "title")
        XCTAssertEqual(alertVerifier.message, "Message", "message")
    }

    func test_tappingShowActionSheetButton_shouldShowActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1, "presented count")
        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertController.Style.actionSheet, "preferred style")
        XCTAssertTrue(alertVerifier.presentingViewController === sut,
                "Expected presenting view controller to be \(String(describing: sut)), but was \(alertVerifier.presentingViewController)")
        XCTAssertTrue(alertVerifier.animated, "animated")
        XCTAssertEqual(alertVerifier.title, "Title", "title")
        XCTAssertEqual(alertVerifier.message, "Message", "message")
    }

    func test_popoverForActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        let popover = alertVerifier.popover!

        XCTAssertEqual(popover.sourceView, sut.showActionSheetButton, "source view")
        XCTAssertEqual("\(popover.sourceRect)", "\(sut.showActionSheetButton.bounds)", "source rect")
        XCTAssertEqual(popover.permittedArrowDirections, UIPopoverArrowDirection.any, "permitted arrow directions")
    }

    func test_actionsForAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actions.count, 4)
        XCTAssertEqual(alertVerifier.actions[0].title, "No Handler")
        XCTAssertEqual(alertVerifier.actions[1].title, "Default")
        XCTAssertEqual(alertVerifier.actions[1].style, .default)
        XCTAssertEqual(alertVerifier.actions[2].title, "Cancel")
        XCTAssertEqual(alertVerifier.actions[2].style, .cancel)
        XCTAssertEqual(alertVerifier.actions[3].title, "Destroy")
        XCTAssertEqual(alertVerifier.actions[3].style, .destructive)
    }

    func test_preferredActionForAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertNotNil(alertVerifier.preferredAction)
//        XCTAssertEqual(alertVerifier.preferredAction?.title, "Default")
    }

    func test_actionsForActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actions.count, 4)
        XCTAssertEqual(alertVerifier.actions[0].title, "No Handler")
        XCTAssertEqual(alertVerifier.actions[1].title, "Default")
        XCTAssertEqual(alertVerifier.actions[1].style, .default)
        XCTAssertEqual(alertVerifier.actions[2].title, "Cancel")
        XCTAssertEqual(alertVerifier.actions[2].style, .cancel)
        XCTAssertEqual(alertVerifier.actions[3].title, "Destroy")
        XCTAssertEqual(alertVerifier.actions[3].style, .destructive)
    }
    
    func test_executeActionForButton_withDefaultButton_shouldExecuteDefaultAction() {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        alertVerifier.executeActionForButton(withTitle: "Default")

        XCTAssertTrue(sut.alertDefaultActionExecuted)
    }

    func test_executeActionForButton_withCancelButton_shouldExecuteCancelAction() {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        alertVerifier.executeActionForButton(withTitle: "Cancel")

        XCTAssertTrue(sut.alertCancelActionExecuted)
    }

    func test_executeActionForButton_withDestroyButton_shouldExecuteDestroyAction() {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        alertVerifier.executeActionForButton(withTitle: "Destroy")

        XCTAssertTrue(sut.alertDestroyActionExecuted)
    }
}
