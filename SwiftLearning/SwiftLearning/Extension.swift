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

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotationKey = "rotation"
        if self.layer.animation(forKey: rotationKey) == nil {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(M_PI * 2.0)
            rotateAnimation.duration = duration
            rotateAnimation.isRemovedOnCompletion = false
            rotateAnimation.repeatCount = Float.infinity
            rotateAnimation.fillMode = kCAFillModeForwards
            rotateAnimation.isCumulative = true
            layer.speed = 1
            layer.timeOffset = 0
            if let delegate = completionDelegate {
                rotateAnimation.delegate = delegate
            }
            self.layer.add(rotateAnimation, forKey: rotationKey)
        } else {
            removeRotation()
            rotate360Degrees(duration: duration, completionDelegate: completionDelegate)
        }
    }
    
    func removeRotation() {
        let rotationKey = "rotation"
        if self.layer.animation(forKey: rotationKey) != nil {
            self.layer.removeAnimation(forKey: rotationKey)
        }
    }
    
    func pauseAnimation() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = layer.timeOffset
        if (pausedTime > 0) {
            layer.speed = 1
            layer.timeOffset = 0
            layer.beginTime = 0
            layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        } else {
            self.rotate360Degrees(duration: 33.3, completionDelegate: nil)
        }
    }
}
