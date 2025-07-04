// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import FailKit
import UIKit

/**
    Captures presented UIAlertControllers.

    Instantiate an AlertVerifier before the execution phase of the test. Then invoke the code to
    create and present your alert. Information about the alert is then available through the
    AlertVerifier.
 */
@MainActor
@objc(QCOAlertVerifier)
public class AlertVerifier: NSObject {
    /// Number of times present(_:animated:completion:) was called.
    @objc public var presentedCount = 0

    @objc public var presentingViewController: UIViewController?
    @objc public var animated: Bool = false
    @objc public var title: String?
    @objc public var message: String?
    @objc public var preferredStyle: UIAlertController.Style = .alert
    @objc public var actions: [UIAlertAction] = []
    @objc public var preferredAction: UIAlertAction?
    #if os(iOS)
        @objc public var popover: UIPopoverPresentationController?
    #endif
    @objc public var textFields: [UITextField]?

    private(set) static var isSwizzled = false

    /// Production code completion handler passed to present(_:animated:completion:).
    @objc public var capturedCompletion: (() -> Void)?

    /// Test code can provide its own completion handler to fulfill XCTestExpectations.
    @objc public var testCompletion: (() -> Void)?

    /**
        Initializes a newly allocated verifier.

        Instantiating an AlertVerifier swizzles UIViewController, UIAlertController, and
        UIAlertAction. They remain swizzled until the AlertVerifier is deallocated. Only one
        AlertVerifier may exist at a time, and none may be created while a PresentationVerifier
        exists. (This is because they both swizzle UIViewController.)
     */
    @objc override public init() {
        super.init()
        guard !AlertVerifier.isSwizzled else {
            Fail().fail(
                message: """
                    More than one instance of AlertVerifier exists. This may be caused by \
                    creating one setUp() but failing to set the property to nil in tearDown().
                    """,
                location: SourceLocation(fileID: #fileID, filePath: #filePath, line: #line, column: #column)
            )
            return
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(alertControllerWasPresented(_:)),
            name: Notification.Name.alertControllerPresented,
            object: nil
        )
        AlertVerifier.swizzleMocksIgnoringActorIsolation()
    }

    deinit {
        AlertVerifier.swizzleMocksIgnoringActorIsolation()
        NotificationCenter.default.removeObserver(self)
    }

    private nonisolated static func swizzleMocksIgnoringActorIsolation() {
        perform(#selector(swizzleMocks))
    }

    @objc private static func swizzleMocks() {
        UIAlertAction.swizzle()
        UIAlertController.swizzle()
        UIViewController.swizzleCaptureAlert()
        AlertVerifier.isSwizzled.toggle()
    }

    @objc private func alertControllerWasPresented(_ notification: Notification) {
        presentedCount += 1
        presentingViewController = notification.userInfo?[presentingViewControllerKey] as? UIViewController
        animated = (notification.userInfo?[animatedKey] as? NSNumber)?.boolValue ?? false
        let closureContainer = notification.userInfo?[completionKey] as? ClosureContainer
        capturedCompletion = closureContainer?.closure
        let alertController = notification.object as? UIAlertController
        title = alertController?.title
        message = alertController?.message
        preferredStyle = alertController?.preferredStyle ?? .alert
        preferredAction = alertController?.preferredAction
        actions = alertController?.actions ?? []
        #if os(iOS)
            popover = alertController?.popoverPresentationController
        #endif
        textFields = alertController?.textFields
        if let completion = testCompletion {
            completion()
        }
    }

    /**
        Executes the action for the button with the specified title.

        Throws an exception (or returns an error in ObjC) if no button with given title is found.
     */
    @objc(executeActionForButton:andReturnError:)
    public func executeAction(forButton title: String) throws {
        let action = try actionWithTitle(title)
        if let handler = action.handler() {
            handler(action)
        }
    }

    private func actionWithTitle(_ title: String) throws -> UIAlertAction {
        for action in actions {
            if action.title == title {
                return action
            }
        }
        throw AlertVerifierErrors.buttonNotFound
    }
}

extension AlertVerifier {
    /**
         Verifies presentation of one alert.
     */
    public func verify(
        title: String?,
        message: String?,
        animated: Bool,
        actions: [Action],
        preferredStyle: UIAlertController.Style = .alert,
        presentingViewController: UIViewController? = nil,
        fileID: String = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        failure: any Failing = Fail()
    ) {
        let continueTest = assertCalledOnce(
            count: presentedCount,
            action: "present",
            fileID: fileID,
            filePath: filePath,
            line: line,
            failure: failure
        )
        guard continueTest else { return }
        expectToEqual(
            actual: self.title,
            expected: title,
            message: "alert title",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        expectToEqual(
            actual: self.message,
            expected: message,
            message: "alert message",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        assertAnimated(
            actual: self.animated,
            expected: animated,
            action: "present",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        verifyActions(
            expected: actions,
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        verifyPreferredStyle(
            expected: preferredStyle,
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
        assertIdentical(
            actual: self.presentingViewController,
            expected: presentingViewController,
            message: "presenting view controller",
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column,
            failure: failure
        )
    }

    private func verifyActions(
        expected: [Action],
        fileID: String = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        failure: any Failing = Fail()
    ) {
        let actual = actionsAsSwiftType()
        let minCount = min(actual.count, expected.count)
        for i in 0 ..< minCount {
            if actual[i] != expected[i] {
                failure.fail(
                    message: "Action \(i): Expected \(expected[i]), but was \(actual[i])",
                    location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
                )
            }
        }
        if actual.count < expected.count {
            let missing = expected[actual.count ..< expected.count].map { $0.description }
            failure.fail(
                message: "Did not meet count of \(expected.count) actions, missing \(missing.joined(separator: ", "))",
                location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
            )
        } else if actual.count > expected.count {
            let extra = actual[expected.count ..< actual.count].map { $0.description }
            failure.fail(
                message: "Exceeded count of \(expected.count) actions, with unexpected \(extra.joined(separator: ", "))",
                location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
            )
        }
    }

    private func actionsAsSwiftType() -> [Action] {
        return actions.map { action in
            switch action.style {
            case .default:
                return .default(action.title)
            case .cancel:
                return .cancel(action.title)
            case .destructive:
                return .destructive(action.title)
            @unknown default:
                fatalError("Unknown UIAlertAction.Style")
            }
        }
    }

    private func verifyPreferredStyle(
        expected: UIAlertController.Style,
        fileID: String = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        failure: any Failing = Fail()
    ) {
        let actual = preferredStyle
        if actual != expected {
            switch expected {
            case .actionSheet:
                failure.fail(
                    message: "Expected preferred style .actionSheet, but was .alert",
                    location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
                )
            case .alert:
                failure.fail(
                    message: "Expected preferred style .alert, but was .actionSheet",
                    location: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
                )
            @unknown default:
                fatalError("Unknown UIAlertController.Style for preferred style")
            }
        }
    }
}

public extension AlertVerifier {
    enum Action: Equatable {
        case `default`(String?)
        case cancel(String?)
        case destructive(String?)
    }
}

extension AlertVerifier.Action: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .default(title):
            return ".default(\(String(describing: title))"
        case let .cancel(title):
            return ".cancel(\(String(describing: title))"
        case let .destructive(title):
            return ".destructive(\(String(describing: title))"
        }
    }
}

@objc enum AlertVerifierErrors: Int, Error {
    case buttonNotFound
}
