import XCTest
@testable import MockUIAlertControllerSampleSwift

class ViewControllerTests: XCTestCase {

    var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController() as! ViewController!
        _ = sut.view
    }
    
    override func tearDown() {
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
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1);
    }
    
    func testTappingShowActionSheetButton_ShouldShowAlert() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1);
    }
    
    func testShowAlert_ShouldPreferAlert() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyle.alert);
    }
    
    func testShowActionSheet_ShouldPreferActionSheet() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertControllerStyle.actionSheet);
    }

    func testShowAlert_ShouldPresentWithAnimation() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.animated, true);
    }
    
    func testShowActionSheet_ShouldPresentWithAnimation() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.animated, true);
    }

    func testShowAlert_PresentedAlertShouldHaveTitle() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.title, "Title");
    }
    
    func testShowActionSheet_PresentedAlertShouldHaveTitle() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.title, "Title");
    }

    func testShowAlert_PresentedAlertShouldHaveMessage() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.message, "Message");
    }

    func testShowActionSheet_PresentedAlertShouldHaveMessage() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.message, "Message");
    }

    func testShowAlert_PresentedAlertShouldHaveActions() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actionTitles?.count, 4);
        XCTAssertEqual(alertVerifier.actionTitles?[0] as? String, "No Handler");
        XCTAssertEqual(alertVerifier.actionTitles?[1] as? String, "Default");
        XCTAssertEqual(alertVerifier.actionTitles?[2] as? String, "Cancel");
        XCTAssertEqual(alertVerifier.actionTitles?[3] as? String, "Destroy");
    }
    
    func testShowActionSheet_PresentedActionSheetShouldHaveActions() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.actionTitles?.count, 4);
        XCTAssertEqual(alertVerifier.actionTitles?[0] as? String, "No Handler");
        XCTAssertEqual(alertVerifier.actionTitles?[1] as? String, "Default");
        XCTAssertEqual(alertVerifier.actionTitles?[2] as? String, "Cancel");
        XCTAssertEqual(alertVerifier.actionTitles?[3] as? String, "Destroy");
    }

    func testShowAlert_DefaultButtonShouldHaveDefaultStyle() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Default"), UIAlertActionStyle.default)
    }
    
    func testShowAlert_CancelButtonShouldHaveCancelStyle() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Cancel"), UIAlertActionStyle.cancel)
    }
    
    func testShowAlert_DestroyButtonShouldHaveDestructiveStyle() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.styleForButton(withTitle: "Destroy"), UIAlertActionStyle.destructive)
    }

    func testShowAlert_ExecutingActionForDefaultButton_ShouldDoSomethingMeaningful() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)
        alertVerifier.executeActionForButton(withTitle: "Default")

        XCTAssertTrue(sut.alertDefaultActionExecuted);
    }
    
    func testShowAlert_ExecutingActionForCancelButton_ShouldDoSomethingMeaningful() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)
        alertVerifier.executeActionForButton(withTitle: "Cancel")

        XCTAssertTrue(sut.alertCancelActionExecuted);
    }
    
    func testShowAlert_ExecutingActionForDestroyButton_ShouldDoSomethingMeaningful() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)
        alertVerifier.executeActionForButton(withTitle: "Destroy")

        XCTAssertTrue(sut.alertDestroyActionExecuted);
    }

    func testShowActionSheet_PopoverSourceViewShouldBeTappedButton() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.popover?.sourceView, sut.showActionSheetButton);
    }
    
    func testShowActionSheet_PopoverSourceRectShouldBeTappedButtonBounds() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(NSStringFromCGRect((alertVerifier.popover?.sourceRect)!),
                       NSStringFromCGRect(sut.showActionSheetButton.bounds));
    }
    
    func testShowActionSheet_PopoverPermittedArrowDirectionsShouldBeAnyDirection() {
        let alertVerifier = QCOMockAlertVerifier()

        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.popover?.permittedArrowDirections, UIPopoverArrowDirection.any);
    }
    
}
