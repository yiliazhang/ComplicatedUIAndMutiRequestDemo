//
//  UIViewController+Appearance.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import UIKit
let tintColor = UIColor(red:0.18, green:0.59, blue:0.91, alpha:1.00)

extension UINavigationController {
    class func initializeOnce() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        navigationBarAppearance.tintColor = UIColor.white//设置tintColor
        navigationBarAppearance.barTintColor = tintColor
        navigationBarAppearance.shadowImage = UIImage()
    }

}


extension UITabBarController {
    public class func initializeOnce() {
        UITabBar.appearance().tintColor = tintColor
        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: tintColor], for: .selected)

    }
}
