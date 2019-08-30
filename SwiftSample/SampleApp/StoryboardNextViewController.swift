import UIKit

final class StoryboardNextViewController: UIViewController {
    var backgroundColor: UIColor!
    var hideToolbar = true
    var viewControllerDismissedCompletion: (() -> Void)? = nil
    @IBOutlet private(set) var toolbar: UIToolbar!
    @IBOutlet private(set) var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        toolbar.isHidden = hideToolbar
    }

    @IBAction private func cancel() {
        dismiss(animated: true, completion: viewControllerDismissedCompletion)
    }
}
