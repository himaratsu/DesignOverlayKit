import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func loadImage(imageUrl: String) {
        imageView.load(imageUrl: imageUrl)
    }
}

extension UIImageView {
    func load(imageUrl: String) {
        let globalQueue = DispatchQueue.global(qos: .default)
        let mainQueue = DispatchQueue.main
        
        globalQueue.async {
            if let url = URL(string: imageUrl) {
                let data = try! Data(contentsOf: url)
                let image = UIImage(data: data)
                
                mainQueue.async {
                    self.image = image
                }
            }
        }
    }
}
