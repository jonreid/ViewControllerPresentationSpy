@testable import SwiftSampleViewControllerPresentationSpy
import XCTest

final class ViewControllerAlertTests: XCTestCase {
    private var alertVerifier: AlertVerifier!
    private var sut: ViewController!

    override func setUp() {
        super.setUp()
        alertVerifier = AlertVerifier()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController
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
                      "Expected presenting view controller to be \(String(describing: sut)), but was \(String(describing: alertVerifier.presentingViewController))")
        XCTAssertTrue(alertVerifier.animated, "animated")
        XCTAssertEqual(alertVerifier.title, "Title", "title")
        XCTAssertEqual(alertVerifier.message, "Message", "message")
    }

    func test_tappingShowActionSheetButton_shouldShowActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.presentedCount, 1, "presented count")
        XCTAssertEqual(alertVerifier.preferredStyle, UIAlertController.Style.actionSheet, "preferred style")
        XCTAssertTrue(alertVerifier.presentingViewController === sut,
                      "Expected presenting view controller to be \(String(describing: sut)), but was \(String(describing: alertVerifier.presentingViewController))")
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

        XCTAssertEqual(alertVerifier.preferredAction?.title, "Default")
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
    
    func test_executeActionForButton_withDefaultButton_shouldExecuteDefaultAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        try alertVerifier.executeActionForButton(withTitle: "Default")

        XCTAssertTrue(sut.alertDefaultActionExecuted)
    }

    func test_executeActionForButton_withCancelButton_shouldExecuteCancelAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        try alertVerifier.executeActionForButton(withTitle: "Cancel")

        XCTAssertTrue(sut.alertCancelActionExecuted)
    }

    func test_executeActionForButton_withDestroyButton_shouldExecuteDestroyAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        try alertVerifier.executeActionForButton(withTitle: "Destroy")

        XCTAssertTrue(sut.alertDestroyActionExecuted)
    }

    func test_textFieldsForAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.textFields?.count, 1)
        XCTAssertEqual(alertVerifier.textFields?[0].placeholder, "Placeholder")
    }

    func test_textFields_shouldNotBeAddedToActionSheets() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.textFields?.count, 0)
    }
}
