//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
//  Copyright 2021 Quality Coding, Inc. See LICENSE.txt

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
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

        alertVerifier.verify(
                title: "Title",
                message: "Message",
                animated: true,
                actions: [
                    .default("No Handler"),
                    .default("Default"),
                    .cancel("Cancel"),
                    .destructive("Destroy"),
                ]
        )
    }

    func test_tappingShowActionSheetButton_shouldShowActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        alertVerifier.verify(
                title: "Title",
                message: "Message",
                animated: true,
                actions: [
                    .default("No Handler"),
                    .default("Default"),
                    .cancel("Cancel"),
                    .destructive("Destroy"),
                ],
                preferredStyle: .actionSheet)
    }

    func test_popoverForActionSheet() {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        let popover = alertVerifier.popover!

        XCTAssertEqual(popover.sourceView, sut.showActionSheetButton, "source view")
        XCTAssertEqual("\(popover.sourceRect)", "\(sut.showActionSheetButton.bounds)", "source rect")
        XCTAssertEqual(popover.permittedArrowDirections, UIPopoverArrowDirection.any, "permitted arrow directions")
    }

    func test_preferredActionForAlert() {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.preferredAction?.title, "Default")
    }

    func test_executeActionForButton_withDefaultButton_shouldExecuteDefaultAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        try alertVerifier.executeAction(forButton: "Default")

        XCTAssertEqual(sut.alertDefaultActionCount, 1)
    }

    func test_executeActionForButton_withCancelButton_shouldExecuteCancelAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        try alertVerifier.executeAction(forButton: "Cancel")

        XCTAssertEqual(sut.alertCancelActionCount, 1)
    }

    func test_executeActionForButton_withDestroyButton_shouldExecuteDestroyAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)
        
        try alertVerifier.executeAction(forButton: "Destroy")

        XCTAssertEqual(sut.alertDestroyActionCount, 1)
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
