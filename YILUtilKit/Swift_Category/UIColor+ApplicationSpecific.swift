/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Application-specific color convenience methods.
*/

import UIKit
//import Hue
extension UIColor {
    class var appTintColor: UIColor {
        return UIColor(red:0.18, green:0.59, blue:0.91, alpha:1.00)
    }
    
    class var placeholderColor: UIColor {
        return UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)
    }
    
    class var buttonNormalColor: UIColor {
        return UIColor.appTintColor
    }

//    class var buttonHighlightedColor: UIColor {
//        return UIColor(hex: "#1976D2")
//    }
//
//    class var buttonDisabledColor: UIColor {
//        return UIColor(hex: "#90caf9")
//    }
//
//    class var formerColor: UIColor {
//        return UIColor(hex: "#222222")
//    }
//
//    class var formerSubColor: UIColor {
//        return UIColor(hex: "#7A7A7A")
//    }

    class var formerHighlightedSubColor:  UIColor {
        return UIColor(red: 1, green: 0.7, blue: 0.12, alpha: 1)
    }
}
