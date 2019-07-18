import UIKit

final class ViewController: UIViewController {
    @IBOutlet private(set) var showAlertButton: UIButton!
    @IBOutlet private(set) var showActionSheetButton: UIButton!
    @IBOutlet private(set) var showModalButton: UIButton!
    @IBOutlet private(set) var segueModalButton: UIButton!

    var alertDefaultActionExecuted = false
    var alertCancelActionExecuted = false
    var alertDestroyActionExecuted = false

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "modal"?:
            guard let nextVC = segue.destination as? StoryboardNextViewController
                    else { return }
            nextVC.backgroundColor = .green
        default:
            return
        }
    }

    @IBAction private func showAlert() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        setUpActions(for: alertController)
        alertController.addTextField { textField in
            textField.placeholder = "Placeholder"
        }
        self.present(alertController, animated: true)
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

    @IBAction private func showModal() {
        let nextVC = CodeNextViewController(backgroundColor: .purple)
        self.present(nextVC, animated: true)
    }


    private func setUpActions(for alertController: UIAlertController) {
        alertDefaultActionExecuted = false
        alertCancelActionExecuted = false
        alertDestroyActionExecuted = false

        let actionWithoutHandler = UIAlertAction.init(title: "No Handler", style: .default)
        let defaultAction = UIAlertAction.init(title: "Default", style: .default) { _ in
            self.alertDefaultActionExecuted = true
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { _ in
            self.alertCancelActionExecuted = true
        }
        let destroyAction = UIAlertAction.init(title: "Destroy", style: .destructive) { _ in
            self.alertDestroyActionExecuted = true
        }

        alertController.addAction(actionWithoutHandler)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        alertController.addAction(destroyAction)
        alertController.preferredAction = defaultAction
    }
    
}
