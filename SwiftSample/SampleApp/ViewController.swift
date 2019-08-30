import UIKit

final class ViewController: UIViewController {
    @IBOutlet private(set) var showAlertButton: UIButton!
    @IBOutlet private(set) var showActionSheetButton: UIButton!
    @IBOutlet private(set) var seguePresentModalButton: UIButton!
    @IBOutlet private(set) var segueShowButton: UIButton!
    @IBOutlet private(set) var codePresentModalButton: UIButton!

    var alertDefaultActionCount = 0
    var alertCancelActionCount = 0
    var alertDestroyActionCount = 0
    var alertPresentedCompletion: (() -> Void)? = nil
    var viewControllerPresentedCompletion: (() -> Void)? = nil

    @IBAction private func showAlert() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        setUpActions(for: alertController)
        alertController.addTextField { textField in
            textField.placeholder = "Placeholder"
        }
        self.present(alertController, animated: true, completion: alertPresentedCompletion)
    }

    @IBAction private func showActionSheet(sender: AnyObject) {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
        setUpActions(for: alertController)

        let popover = alertController.popoverPresentationController
        if let popover = popover {
            popover.sourceView = sender as? UIView
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .any
        }

        self.present(alertController, animated: true)
    }

    private func setUpActions(for alertController: UIAlertController) {
        alertDefaultActionCount = 0
        alertCancelActionCount = 0
        alertDestroyActionCount = 0

        let actionWithoutHandler = UIAlertAction.init(title: "No Handler", style: .default)
        let defaultAction = UIAlertAction.init(title: "Default", style: .default) { _ in
            self.alertDefaultActionCount += 1
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { _ in
            self.alertCancelActionCount += 1
        }
        let destroyAction = UIAlertAction.init(title: "Destroy", style: .destructive) { _ in
            self.alertDestroyActionCount += 1
        }

        alertController.addAction(actionWithoutHandler)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        alertController.addAction(destroyAction)
        alertController.preferredAction = defaultAction
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "presentModal"?:
            guard let nextVC = segue.destination as? StoryboardNextViewController else { return }
            nextVC.backgroundColor = .green
            nextVC.hideToolbar = false
        case "show"?:
            guard let nextVC = segue.destination as? StoryboardNextViewController else { return }
            nextVC.backgroundColor = .red
            nextVC.hideToolbar = true
        default:
            return
        }
    }

    @IBAction private func showModal() {
        let nextVC = CodeNextViewController(backgroundColor: .purple)
        self.present(nextVC, animated: true, completion: viewControllerPresentedCompletion)
    }
}
