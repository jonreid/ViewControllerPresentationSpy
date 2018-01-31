import XCTest
@testable import MockUIAlertControllerSampleSwift

class ViewControllerTests: XCTestCase {
    var alertVerifier: QCOMockAlertVerifier!
    var sut: ViewController!

    override func setUp() {
        super.setUp()
        alertVerifier = QCOMockAlertVerifier()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController() as! ViewController!
        _ = sut.view
    }

    override func tearDown() {
        alertVerifier = nil
        sut = nil
        super.tearDown()
    }

    func testShowAlertButton_ShouldBeConnected() {
        XCTAssertNotNil(sut.showAlertButton)
    }

    func testShowActionSheetButton_ShouldBeConnected() {
        XCTAssertNotNil(sut.showActionSheetButton)
    }

    func testTappingShowAlertButton_ShouldShowAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1);
    }

    func testTappingShowActionSheetButton_ShouldShowAlert() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1);
    }

    func testShowAlert_ShouldPreferAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyle.alert);
    }

    func testShowActionSheet_ShouldPreferActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyle.actionSheet);
    }

    func testShowAlert_ShouldPresentWithAnimation() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(alertVerifier.animated);
    }

    func testShowActionSheet_ShouldPresentWithAnimation() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(alertVerifier.animated);
    }

    func testShowAlert_PresentedAlertShouldHaveTitle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.title, "Title");
    }

    func testShowActionSheet_PresentedAlertShouldHaveTitle() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.title, "Title");
    }

    func testShowAlert_PresentedAlertShouldHaveMessage() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.message, "Message");
    }

    func testShowActionSheet_PresentedAlertShouldHaveMessage() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.message, "Message");
    }

    func testShowAlert_PresentedAlertShouldHaveActions() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actionTitles.count, 4);
        XCTAssertEqual(alertVerifier.actionTitles[0] as? String, "No Handler");
        XCTAssertEqual(alertVerifier.actionTitles[1] as? String, "Default");
        XCTAssertEqual(alertVerifier.actionTitles[2] as? String, "Cancel");
        XCTAssertEqual(alertVerifier.actionTitles[3] as? String, "Destroy");
    }

    func testShowActionSheet_PresentedActionSheetShouldHaveActions() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actionTitles.count, 4);
        XCTAssertEqual(alertVerifier.actionTitles[0] as? String, "No Handler");
        XCTAssertEqual(alertVerifier.actionTitles[1] as? String, "Default");
        XCTAssertEqual(alertVerifier.actionTitles[2] as? String, "Cancel");
        XCTAssertEqual(alertVerifier.actionTitles[3] as? String, "Destroy");
    }

    func testShowAlert_DefaultButtonShouldHaveDefaultStyle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Default"), UIAlertActionStyle.default)
    }

    func testShowAlert_CancelButtonShouldHaveCancelStyle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Cancel"), UIAlertActionStyle.cancel)
    }

    func testShowAlert_DestroyButtonShouldHaveDestructiveStyle() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Destroy"), UIAlertActionStyle.destructive)
    }

    func testShowAlert_ExecutingActionForDefaultButton_ShouldDoSomethingMeaningful() {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        alertVerifier.executeActionForButton(withTitle: "Default")

        XCTAssertTrue(sut.alertDefaultActionExecuted);
    }

    func testShowAlert_ExecutingActionForCancelButton_ShouldDoSomethingMeaningful() {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        alertVerifier.executeActionForButton(withTitle: "Cancel")

        XCTAssertTrue(sut.alertCancelActionExecuted);
    }

    func testShowAlert_ExecutingActionForDestroyButton_ShouldDoSomethingMeaningful() {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        alertVerifier.executeActionForButton(withTitle: "Destroy")

        XCTAssertTrue(sut.alertDestroyActionExecuted);
    }

    func testShowActionSheet_PopoverSourceViewShouldBeTappedButton() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.popover?.sourceView, sut.showActionSheetButton);
    }

    func testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(NSStringFromCGRect((alertVerifier.popover?.sourceRect)!),
                NSStringFromCGRect(sut.showActionSheetButton.bounds));
    }

    func testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.popover?.permittedArrowDirections, UIPopoverArrowDirection.any);
    }

}
