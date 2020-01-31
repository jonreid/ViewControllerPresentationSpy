//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2020 Quality Coding, Inc. See LICENSE.txt

import XCTest
import UIKit

/**
    Captures presented UIAlertControllers.
 
    Instantiate an AlertVerifier before the execution phase of the test. Then invoke the code to
    create and present your alert. Information about the alert is then available through the
    AlertVerifier.
 */
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
    @objc public var popover: UIPopoverPresentationController?
    @objc public var textFields: [UITextField]?

    static private(set) var isSwizzled = false

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
    @objc public override init() {
        super.init()
        guard !AlertVerifier.isSwizzled else {
            XCTFail("""
                    More than one instance of AlertVerifier exists. This may be caused by \
                    creating one setUp() but failing to set the property to nil in tearDown().
                    """)
            return
        }
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(alertControllerWasPresented(_:)),
                name: NSNotification.Name.QCOMockAlertControllerPresented,
                object: nil
        )
        AlertVerifier.swizzleMocks()
    }

    deinit {
        AlertVerifier.swizzleMocks()
        NotificationCenter.default.removeObserver(self)
    }

    private static func swizzleMocks() {
        UIAlertAction.qcoMock_swizzle()
        UIAlertController.qcoMock_swizzle()
        UIViewController.qcoMock_swizzleCaptureAlert()
        AlertVerifier.isSwizzled.toggle()
    }

    @objc private func alertControllerWasPresented(_ notification: Notification) {
        presentedCount += 1
        presentingViewController = notification.userInfo?[QCOMockViewControllerPresentingViewControllerKey] as? UIViewController
        animated = (notification.userInfo?[QCOMockViewControllerAnimatedKey] as? NSNumber)?.boolValue ?? false
        let closureContainer = notification.userInfo?[QCOMockViewControllerCompletionKey] as? ClosureContainer
        capturedCompletion = closureContainer?.closure
        let alertController = notification.object as? UIAlertController
        title = alertController?.title
        message = alertController?.message
        preferredStyle = alertController?.preferredStyle ?? .alert
        preferredAction = alertController?.preferredAction
        actions = alertController?.actions ?? []
        popover = alertController?.popoverPresentationController
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
        if let handler = action.qcoMock_handler() {
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
            file: StaticString = #file,
            line: UInt = #line) {
        let abort = verifyCallCount(actual: self.presentedCount, action: "present", file: file, line: line)
        if abort { return }
        XCTAssertEqual(self.title, title, "alert title", file: file, line: line)
        XCTAssertEqual(self.message, message, "alert message", file: file, line: line)
        verifyAnimated(actual: self.animated, expected: animated, action: "present", file: file, line: line)
        verifyActions(expected: actions, file: file, line: line)
        verifyPreferredStyle(expected: preferredStyle, file: file, line: line)
        verifyViewController(actual: self.presentingViewController, expected: presentingViewController,
                adjective: "presenting", file: file, line: line)
    }

    private func verifyActions(expected: [Action], file: StaticString, line: UInt) {
        let actual = actionsAsSwiftType()
        let minCount = min(actual.count, expected.count)
        for i in 0 ..< minCount {
            if actual[i] != expected[i] {
                XCTFail("Action \(i): Expected \(expected[i]), but was \(actual[i])",
                        file: file, line: line)
            }
        }
        if actual.count < expected.count {
            let missing = expected[actual.count ..< expected.count].map{ $0.description }
            XCTFail("Did not meet count of \(expected.count) actions, missing \(missing.joined(separator: ", "))",
                    file: file, line: line)
        } else if actual.count > expected.count {
            let extra = actual[expected.count ..< actual.count].map{ $0.description }
            XCTFail("Exceeded count of \(expected.count) actions, with unexpected \(extra.joined(separator: ", "))",
                    file: file, line: line)
        }
    }

    func actionsAsSwiftType() -> [Action] {
        return self.actions.map { action in
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

    private func verifyPreferredStyle(expected: UIAlertController.Style,
                                      file: StaticString,
                                      line: UInt) {
        let actual = self.preferredStyle
        if actual != expected {
            switch expected {
            case .actionSheet:
                XCTFail("Expected preferred style .actionSheet, but was .alert", file: file, line: line)
            case .alert:
                XCTFail("Expected preferred style .alert, but was .actionSheet", file: file, line: line)
            @unknown default:
                fatalError("Unknown UIAlertController.Style for preferred style")
            }
        }
    }
}

extension AlertVerifier {
    public enum Action: Equatable {
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
