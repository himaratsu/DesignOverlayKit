import UIKit
import DesignOverlayKit

class ViewController: UIViewController {

    var gridView: GridView?
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        title = "Design Overlay サンプルアプリ"
        tableView.frame = self.view.frame
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "デバッグ",
            style: .done,
            target: self,
            action: #selector(debugButtonTouched)
        )
    }
    
    @objc func debugButtonTouched() {
        if self.gridView != nil {
            gridView?.removeFromSuperview()
            self.gridView = nil
            return
        }
        self.gridView = GridView.show()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "テスト \(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = DetailViewController()
        show(detailVC, sender: nil)
        
    }
}
