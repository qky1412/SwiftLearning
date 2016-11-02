//
//  ColorExtension.swift
//  SwiftLearning
//
//  Created by qky on 16/11/2.
//  Copyright © 2016年 boostfield. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    //for hex init
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func appPrimaryColor() -> UIColor {
        return UIColor(netHex: 0xC1B087)
    }
    
    class func appBrownColor() -> UIColor {
        return UIColor(netHex: 0x9C743C)
    }
    
    class func appBlackColor() -> UIColor {
        return UIColor(netHex: 0x3C372F)
    }
    
}
