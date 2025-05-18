// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class ViewControllerAlertTests: XCTestCase, Sendable {
    private var alertVerifier: AlertVerifier!
    private var sut: ViewController!

    override func setUp() async throws {
        try await super.setUp()
        alertVerifier = AlertVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }

    override func tearDown() async throws {
        alertVerifier = nil
        sut = nil
        try await super.tearDown()
    }

    func test_outlets_areConnected() throws {
        XCTAssertNotNil(sut.showAlertButton)
        XCTAssertNotNil(sut.showActionSheetButton)
    }

    func test_tappingShowAlertButton_showsAlert() throws {
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

    func test_tappingShowActionSheetButton_showsActionSheet() throws {
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
            preferredStyle: .actionSheet
        )
    }

    func test_popoverForActionSheet() throws {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        let popover = try XCTUnwrap(alertVerifier.popover)

        XCTAssertEqual(popover.sourceView, sut.showActionSheetButton, "source view")
        XCTAssertEqual("\(popover.sourceRect)", "\(sut.showActionSheetButton.bounds)", "source rect")
        XCTAssertEqual(popover.permittedArrowDirections, UIPopoverArrowDirection.any, "permitted arrow directions")
    }

    func test_preferredActionForAlert() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.preferredAction?.title, "Default")
    }

    func test_executeActionForButton_withDefaultButton_executesDefaultAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        try alertVerifier.executeAction(forButton: "Default")

        XCTAssertEqual(sut.alertDefaultActionCount, 1)
    }

    func test_executeActionForButton_withCancelButton_executesCancelAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        try alertVerifier.executeAction(forButton: "Cancel")

        XCTAssertEqual(sut.alertCancelActionCount, 1)
    }

    func test_executeActionForButton_withDestroyButton_executesDestroyAction() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        try alertVerifier.executeAction(forButton: "Destroy")

        XCTAssertEqual(sut.alertDestroyActionCount, 1)
    }

    func test_textFieldsForAlert() throws {
        sut.showAlertButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.textFields?.count, 1)
        XCTAssertEqual(alertVerifier.textFields?[0].placeholder, "Placeholder")
    }

    func test_textFieldsAreNotAddedToActionSheets() throws {
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(alertVerifier.textFields?.count, 0)
    }
}
