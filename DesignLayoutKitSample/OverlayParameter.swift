import Foundation
import UIKit

class OverlayParameter {
    var isGridEnable = true
    var gridSize: Int = 15
    var gridColor = UIColor.hex("#3498db")
}

extension UIColor {
    class func hex (_ hexStr: String) -> UIColor {
        return UIColor.hex(hexStr, alpha:1.0)
    }
    
    class func hex (_ hexStr: String, alpha: CGFloat) -> UIColor {
        let replacedHexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: replacedHexStr)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r, green:g, blue:b, alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }
}
