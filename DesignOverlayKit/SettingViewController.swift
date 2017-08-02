import UIKit

class SettingViewController: UIViewController {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let closeButton = UIButton()
    var overlayParameter = DesignOverlay.Parameter()

    var fromViewController: UIViewController?
    var overlay: DesignOverlay?
    
    var currentField: UITextField?
    var sizeField: UITextField?

    class func show(from overlay: DesignOverlay, parameter: DesignOverlay.Parameter = DesignOverlay.Parameter()) {
        let settingVC = SettingViewController()
        let navVC = UINavigationController(rootViewController: settingVC)
        if let window = UIApplication.shared.keyWindow {
            settingVC.fromViewController = window.rootViewController
            settingVC.overlay = overlay
            settingVC.overlayParameter = parameter

            UIApplication.shared.topViewController()?.present(navVC, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureSubviews()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overlay?.settingButton.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        overlay?.settingButton.isHidden = false
        super.viewWillDisappear(animated)
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(closeButton)
    }

    func configureSubviews() {
        title = "Design Overlay"
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.allowsSelection = false

        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.hex("#3498db"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        closeButton.backgroundColor = .white
        
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
    }

    func configureLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        closeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    @objc func closeButtonTouched() {
        dismiss(animated: true) { [weak self] in
            if let weakSelf = self {
                weakSelf.overlay?.overlayParameter = weakSelf.overlayParameter
                weakSelf.overlay?.refresh()
            }
        }
    }

}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
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
            textField.inputAccessoryView = createAccessoryView(with: .size)
            
            sizeField = textField
            
            cell.textLabel?.text = "Size"
            cell.accessoryView = textField
            return cell
        } else if indexPath.row == 2 {
            let textField = MarginTextField()
            textField.text = "#3498db"
            textField.placeholder = "#CCCCCC"
            textField.frame = CGRect(x: 0, y: 0, width: 100, height: 36)
            textField.tag = 2
            textField.delegate = self
            textField.returnKeyType = .done
            textField.inputAccessoryView = createAccessoryView(with: .color)
            cell.textLabel?.text = "Color"
            cell.accessoryView = textField
            return cell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Grid"
    }

    @objc func gridEnableSwitchChanged(_ sw: UISwitch) {
        overlayParameter.isGridEnable = sw.isOn
        overlay?.refresh()
    }
    
    enum AccessoryType {
        case size
        case color
    }
    private func createAccessoryView(with type: AccessoryType) -> UIView {
        let view = UIView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 36)
        )
        view.backgroundColor = .hex("#F6F6F6")
        
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
        
        if type == .size {
            for i in 1...3 {
                let pixelSize: Int = i * 5
                
                let button = UIButton(type: .custom)
                button.tag = pixelSize
                button.setTitle("\(pixelSize)px", for: .normal)
                button.addTarget(self, action: #selector(pixelButtonTouched(_:)), for: .touchUpInside)
                button.backgroundColor = UIColor.hex("#3498db")
                button.setTitleColor(UIColor.hex("#FFFFFF"), for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                button.layer.masksToBounds = true
                button.layer.cornerRadius = 3.0
                button.clipsToBounds = true
                
                stackView.addArrangedSubview(button)
            }
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("完了", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTouched), for: .touchUpInside)
        button.backgroundColor = UIColor.hex("#FFFFFF")
        button.setTitleColor(UIColor.hex("#333333"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.clipsToBounds = true
        stackView.addArrangedSubview(button)
        
        return view
    }
    
    @objc private func doneButtonTouched() {
        currentField?.resignFirstResponder()
    }
    
    @objc private func pixelButtonTouched(_ button: UIButton) {
        sizeField?.text = "\(button.tag)"
        overlayParameter.gridSize = button.tag
        overlay?.refresh()
    }
}

extension SettingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if let text = textField.text,
                let gridSize = Int(text) {
                overlayParameter.gridSize = gridSize
                overlay?.refresh()
            }
        } else if textField.tag == 2 {
            guard let text = textField.text else { return }
            overlayParameter.gridColor = UIColor.hex(text)
            overlay?.refresh()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIApplication {
    func topViewController() -> UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}
