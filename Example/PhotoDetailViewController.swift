import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    var photo: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            titleLabel.text = photo["title"] as? String
            if let imageUrl = photo["url_z"] as? String {
                imageView.load(imageUrl: imageUrl)
            }
        }
    }
}
