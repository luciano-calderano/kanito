//
//  MYColor
//  Enci
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

extension UIColor {
    static func hexColor(_ hex: String) -> UIColor {
        return UIColor.init(netHex: Int(hex, radix: 16)!)
    }
    
    @nonobjc static let myBlueLight  = UIColor.hexColor("00aed9")
    @nonobjc static let myGreyLight  = UIColor.hexColor("f9f9f9")
    @nonobjc static let myGreyMedium = UIColor.hexColor("a9a9a9")
    @nonobjc static let myGreyDark   = UIColor.hexColor("4c505c")
    @nonobjc static let myOrange     = UIColor.hexColor("f29100")
    @nonobjc static let myBizGreen   = UIColor.hexColor("0d8489")
    @nonobjc static let mySilver     = UIColor.hexColor("dce0e0")
    
    convenience init(r: Int, g: Int, b: Int) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(r:(netHex >> 16) & 0xff, g:(netHex >> 8) & 0xff, b:netHex & 0xff)
    }
}
