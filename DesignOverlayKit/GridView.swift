import UIKit

public class GridView: UIView {

    var overlayParameter = OverlayParameter() {
        didSet {
            setNeedsLayout()
        }
    }
    private let designImageView = UIImageView()
    let settingButton = UIButton(type: UIButtonType.infoDark)
    private let settingVC = SettingViewController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        constructViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class public func show(with parameter: OverlayParameter = OverlayParameter(), isNeedSettingButton: Bool = true) -> GridView {
        let gridView = GridView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        gridView.overlayParameter = parameter
        gridView.settingButton.isHidden = !isNeedSettingButton
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(gridView)
        }
        return gridView
    }

    private func constructViews() {
        settingButton.addTarget(self, action: #selector(showSetting), for: .touchUpInside)
        
        addSubview(settingButton)

        refresh()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let posY: CGFloat
        if #available(iOS 11.0, *) {
            posY = 10 + safeAreaInsets.top
        } else {
            posY = 10
        }
        settingButton.frame.origin = CGPoint(x: 10, y: posY)
    }

    private func constructPathes() -> [[CGPoint]] {
        var pointsList = [[CGPoint]]()

        let gridSize = overlayParameter.gridSize
        if gridSize == 0 {
            return []
        }

        var x = CGFloat(gridSize)
        while (x <= self.frame.size.width) {
            var points = [CGPoint]()
            points.append(CGPoint(x: x, y: 0))
            points.append(CGPoint(x: x, y: self.frame.size.height))

            pointsList.append(points)
            x += CGFloat(gridSize)
        }

        var y = CGFloat(gridSize)
        while (y <= self.frame.size.height) {
            var points = [CGPoint]()
            points.append(CGPoint(x: 0, y: y))
            points.append(CGPoint(x: self.frame.size.width, y: y))

            pointsList.append(points)
            y += CGFloat(gridSize)
        }

        return pointsList
    }

    func refresh() {
        setNeedsDisplay()
    }

    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)

        if !overlayParameter.isGridEnable { return }

        let pointsList = constructPathes()
        
        for points in pointsList {
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            overlayParameter.gridColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
            context?.setLineWidth(0.5)
            context?.addLines(between: points)
            context?.strokePath()
        }
    }

    @objc private func showSetting() {
        SettingViewController.show(from: self, parameter: overlayParameter)
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == settingButton {
            return settingButton
        } else if hitView == settingVC.tableView {
            return settingVC.tableView
        } else if hitView == settingVC.closeButton {
            return settingVC.closeButton
        }

        return nil
    }
}
