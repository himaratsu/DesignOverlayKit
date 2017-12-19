import UIKit

class SettingViewController: UIViewController {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let closeButton = UIButton()
    var overlayParameter = OverlayParameter()
    var gridView: GridView?

    var fromViewController: UIViewController?
    var fromGridView: GridView?

    class func show(from fromGridView: GridView, parameter: OverlayParameter = OverlayParameter()) {
        let settingVC = SettingViewController()
        let navVC = UINavigationController(rootViewController: settingVC)
        if let window = UIApplication.shared.keyWindow {
            settingVC.fromViewController = window.rootViewController
            settingVC.fromGridView = fromGridView
            settingVC.overlayParameter = parameter

            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = navVC
            }, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureSubviews()
        configureLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.gridView != nil { return }
        self.gridView = GridView.show(with: overlayParameter, isNeedSettingButton: false)
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(closeButton)
    }

    func configureSubviews() {
        title = "Setting"
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        closeButton.setTitle("Close", for: .normal)
        closeButton.tintColor = UIColor.gray
        closeButton.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
    }

    func configureLayout() {
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 44)
        closeButton.frame = CGRect(x: 0, y: tableView.frame.size.height, width: UIScreen.main.bounds.size.width, height: 44)
    }

    func closeButtonTouched() {
        if let window = UIApplication.shared.keyWindow {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = self.fromViewController

                window.addSubview(self.fromGridView!)
                self.fromGridView?.overlayParameter = self.overlayParameter
                self.fromGridView?.refresh()
            }, completion: nil)
        }
    }

}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Enable"
                let enableSwitch = UISwitch()
                enableSwitch.isOn = overlayParameter.isDesignEnable
                enableSwitch.addTarget(self, action: #selector(designEnableSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = enableSwitch
                return cell
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Capture"
                let imageView = UIImageView()
                imageView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
                imageView.image = overlayParameter.designImage
                imageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(designImageTouched))
                imageView.addGestureRecognizer(tapGesture)
                cell.accessoryView = imageView
                return cell
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Alpha"
                let sliderView = UISlider()
                sliderView.value = Float(overlayParameter.designAlpha)
                sliderView.addTarget(self, action: #selector(designAlphaChanged(_:)), for: .valueChanged)
                cell.accessoryView = sliderView
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Enable"
                let enableSwitch = UISwitch()
                enableSwitch.isOn = overlayParameter.isGridEnable
                enableSwitch.addTarget(self, action: #selector(gridEnableSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = enableSwitch
                return cell
            } else if indexPath.row == 1 {
                let textField = MarginTextField()
                textField.frame = CGRect(x: 0, y: 0, width: 40, height: 36)
                textField.placeholder = "px"
                textField.text = "\(overlayParameter.gridSize)"
                textField.delegate = self
                textField.tag = 1
                textField.keyboardType = .numberPad
                textField.returnKeyType = .done
                cell.textLabel?.text = "Size"
                cell.accessoryView = textField
                return cell
            } else if indexPath.row == 2 {
                let textField = MarginTextField()
                textField.text = "#CCCCCC"
                textField.frame = CGRect(x: 0, y: 0, width: 100, height: 36)
                textField.tag = 2
                textField.delegate = self
                textField.returnKeyType = .done
                cell.textLabel?.text = "Color"
                cell.accessoryView = textField
                return cell
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Design"
        } else if section == 1 {
            return "Grid"
        } else {
            return nil
        }
    }

    func designEnableSwitchChanged(_ sw: UISwitch) {
        overlayParameter.isDesignEnable = sw.isOn
        gridView?.refresh()
    }

    func designImageTouched() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary

        gridView?.isHidden = true
        present(picker, animated: true, completion: nil)
    }

    func designAlphaChanged(_ slider: UISlider) {
        overlayParameter.designAlpha = CGFloat(slider.value)
        gridView?.refresh()
    }

    func gridEnableSwitchChanged(_ sw: UISwitch) {
        overlayParameter.isGridEnable = sw.isOn
        gridView?.refresh()
    }
}

extension SettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if let text = textField.text,
                let gridSize = Int(text) {
                overlayParameter.gridSize = gridSize
                gridView?.refresh()
            }
        } else if textField.tag == 2 {
            guard let text = textField.text else { return }
            overlayParameter.gridColor = UIColor.hex(text)
            gridView?.refresh()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        gridView?.isHidden = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let chosenImage = info[UIImagePickerControllerOriginalImage]
        overlayParameter.designImage = chosenImage as? UIImage
        gridView?.refresh()

        picker.dismiss(animated: true, completion: { _ in })
        gridView?.isHidden = false

        tableView.reloadData()
    }
}

class MarginTextField: UITextField {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true

        self.font = UIFont.systemFont(ofSize: 14.0)
        self.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        self.textAlignment = .center

        self.inputAccessoryView = createAccessoryView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createAccessoryView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 36))
        let button = UIButton(type: .custom)
        button.setTitle("完了", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTouched), for: .touchUpInside)
        button.backgroundColor = UIColor.hex("0xEFEFEF")
        button.setTitleColor(UIColor.hex("0x333333"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        button.frame = CGRect(x: 0, y: 1, width: 60, height: 35)
        view.addSubview(button)

        return view
    }

    func doneButtonTouched() {
        self.resignFirstResponder()
    }
}
