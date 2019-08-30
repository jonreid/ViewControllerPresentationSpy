import UIKit

final class StoryboardNextViewController: UIViewController {
    var backgroundColor: UIColor!
    var hideToolbar = true
    @IBOutlet private(set) var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        toolbar.isHidden = hideToolbar
    }
}
