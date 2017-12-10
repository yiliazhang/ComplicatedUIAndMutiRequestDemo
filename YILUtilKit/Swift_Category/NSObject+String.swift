//
//  NSObject+String.swift
//  Demo
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
extension YIL where Base: NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
