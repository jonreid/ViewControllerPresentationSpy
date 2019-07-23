//  ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 Jonathan M. Reid. See LICENSE.txt

import UIKit

/*!
 * @abstract Captures presented UIAlertControllers.
 * @discussion Instantiate an AlertVerifier before the execution phase of the test. Then invoke the
 * code to create and present your alert. Information about the alert is then available through the
 * AlertVerifier.
 */
@objc(QCOAlertVerifier)
public class AlertVerifier: NSObject {
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
    @objc public var capturedCompletion: (() -> Void)?
    @objc public var completion: (() -> Void)?

    /*!
     * @abstract Initializes a newly allocated verifier.
     * @discussion Instantiating an AlertVerifier swizzles UIViewController and UIAlertController.
     * They remain swizzled until the AlertVerifier is deallocated.
     */
    @objc public override init() {
        super.init()
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
        if let completion = completion {
            completion()
        }
    }

    /*!
     * @abstract Executes the action for the button with the specified title.
     * @discussion Throws an exception (or returns an error in ObjC) if no button with that title is
     * found.
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

@objc enum AlertVerifierErrors: Int, Error {
    case buttonNotFound
}
