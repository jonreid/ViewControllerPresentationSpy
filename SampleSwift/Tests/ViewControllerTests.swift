@testable import MockUIAlertControllerSampleSwift
import XCTest

class ViewControllerTests: XCTestCase {
    var alertVerifier: QCOMockAlertVerifier!
    var sut: ViewController!

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

    func test_actionSheetPopover() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        let popover = alertVerifier.popover

        XCTAssertEqual(popover?.sourceView, sut.showActionSheetButton, "source view")
        XCTAssertEqual(NSCoder.string(for: (popover?.sourceRect)!),
                NSCoder.string(for: sut.showActionSheetButton.bounds),
                "source rect")
        XCTAssertEqual(popover?.permittedArrowDirections, UIPopoverArrowDirection.any, "permitted arrow directions")
    }

    func test_presentedAlert_shouldHaveActions() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actionTitles.count, 4)
        XCTAssertEqual(alertVerifier.actionTitles[0] as? String, "No Handler")
        XCTAssertEqual(alertVerifier.actionTitles[1] as? String, "Default")
        XCTAssertEqual(alertVerifier.actionTitles[2] as? String, "Cancel")
        XCTAssertEqual(alertVerifier.actionTitles[3] as? String, "Destroy")
    }

    func test_showingActionSheet_presentedActionSheetShouldHaveActions() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actionTitles.count, 4)
        XCTAssertEqual(alertVerifier.actionTitles[0] as? String, "No Handler")
        XCTAssertEqual(alertVerifier.actionTitles[1] as? String, "Default")
        XCTAssertEqual(alertVerifier.actionTitles[2] as? String, "Cancel")
        XCTAssertEqual(alertVerifier.actionTitles[3] as? String, "Destroy")
    }

    func test_styleForButton_withDefaultButton_shouldHaveDefaultStyle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Default"), UIAlertAction.Style.default)
    }

    func test_styleForButton_withCancelButton_shouldHaveCancelStyle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Cancel"), UIAlertAction.Style.cancel)
    }

    func test_styleForButton_withDestroyButton_shouldHaveDestructiveStyle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Destroy"), UIAlertAction.Style.destructive)
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
