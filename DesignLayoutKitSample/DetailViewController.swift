import UIKit

class DetailViewController: UIViewController {

    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.frame = self.view.frame
        label.text = "HELLO WORLD"
    }
    
}
