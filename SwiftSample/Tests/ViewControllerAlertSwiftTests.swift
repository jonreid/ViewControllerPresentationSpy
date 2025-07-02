// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import Testing
import UIKit

@MainActor
final class ViewControllerAlertSwiftTests: @unchecked Sendable {
    private let sut: ViewController

    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }

    @Test("outlets are connected")
    func outlets_areConnected() throws {
        #expect(sut.showAlertButton != nil)
        #expect(sut.showActionSheetButton != nil)
    }

    @Test("tapping show alert button shows alert")
    func tappingShowAlertButton_showsAlert() throws {
        let alertVerifier = AlertVerifier()

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

    @Test("tapping show action sheet button shows action sheet")
    func tappingShowActionSheetButton_showsActionSheet() throws {
        let alertVerifier = AlertVerifier()

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

    @Test("popover for action sheet")
    func popoverForActionSheet() throws {
        let alertVerifier = AlertVerifier()
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        let popover = try #require(alertVerifier.popover)

        #expect(popover.sourceView == sut.showActionSheetButton, "source view")
        #expect("\(popover.sourceRect)" == "\(sut.showActionSheetButton.bounds)", "source rect")
        #expect(popover.permittedArrowDirections == UIPopoverArrowDirection.any, "permitted arrow directions")
    }

    @Test("preferred action for alert")
    func preferredActionForAlert() throws {
        let alertVerifier = AlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        #expect(alertVerifier.preferredAction?.title == "Default")
    }

    @Test("execute action for button with default button executes default action")
    func executeActionForButton_withDefaultButton_executesDefaultAction() throws {
        let alertVerifier = AlertVerifier()
        sut.showAlertButton.sendActions(for: .touchUpInside)

        try alertVerifier.executeAction(forButton: "Default")

        #expect(sut.alertDefaultActionCount == 1)
    }

    @Test("execute action for button with cancel button executes cancel action")
    func executeActionForButton_withCancelButton_executesCancelAction() throws {
        let alertVerifier = AlertVerifier()
        sut.showAlertButton.sendActions(for: .touchUpInside)

        try alertVerifier.executeAction(forButton: "Cancel")

        #expect(sut.alertCancelActionCount == 1)
    }

    @Test("execute action for button with destroy button executes destroy action")
    func executeActionForButton_withDestroyButton_executesDestroyAction() throws {
        let alertVerifier = AlertVerifier()
        sut.showAlertButton.sendActions(for: .touchUpInside)

        try alertVerifier.executeAction(forButton: "Destroy")

        #expect(sut.alertDestroyActionCount == 1)
    }

    @Test("text fields for alert")
    func textFieldsForAlert() throws {
        let alertVerifier = AlertVerifier()

        sut.showAlertButton.sendActions(for: .touchUpInside)

        #expect(alertVerifier.textFields?.count == 1)
        #expect(alertVerifier.textFields?[0].placeholder == "Placeholder")
    }

    @Test("text fields are not added to action sheets")
    func textFieldsAreNotAddedToActionSheets() throws {
        let alertVerifier = AlertVerifier()
        
        sut.showActionSheetButton.sendActions(for: .touchUpInside)

        #expect(alertVerifier.textFields?.count == 0)
    }
} 
