import UIKit
import DesignOverlayKit

class ViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    private var photos: [[String: Any]] = []
    
    private var isDebugMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        request()
    }

    @IBAction private func debugButtonTouched(_ sender: Any) {
        isDebugMode = !isDebugMode
        if isDebugMode {
            DesignOverlay.show()
        } else {
            DesignOverlay.hide()
        }
    }
    
    private func request() {
        let flickrApiUrl = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=86997f23273f5a518b027e2c8c019b0f&format=json&extras=url_q,url_z&nojsoncallback=1"
        guard let url = URL(string: flickrApiUrl) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("### [ERROR] request was failed.")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            if let json = json as? [String: Any],
                let photos = json["photos"] as? [String: Any],
                let photo = photos["photo"] as? [[String: Any]] {
                self.photos = photo
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destVC = segue.destination as? PhotoDetailViewController,
            let photo = sender as? [String: Any] {
                destVC.photo = photo
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        if let imageUrl = photos[indexPath.row]["url_q"] as? String {
            cell.loadImage(imageUrl: imageUrl)
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: photos[indexPath.row])
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.size.width - 15*4) / 3
        return CGSize(width: cellSize, height: cellSize)
    }
}

