import UIKit

final class CodeNextViewController: UIViewController {
    let backgroundColor: UIColor

    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
    }
}
