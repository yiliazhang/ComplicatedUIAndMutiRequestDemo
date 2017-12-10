//
//  YIL.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import UIKit
public final class YIL<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol YILCompatible {
    associatedtype CompatibleType
    var yil: CompatibleType { get }
}

public extension YILCompatible {
    public var yil: YIL<Self> {
        get { return YIL(self) }
    }
}

extension UIViewController: YILCompatible{}
extension UIImage: YILCompatible{}
extension UIView: YILCompatible{}
extension UIColor: YILCompatible{}
extension NSObject: YILCompatible{}
