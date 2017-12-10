//
//  String+Object.swift
//  MOSP
//
//  Created by apple on 2017/11/11.
//

import Foundation
import UIKit
extension String {
    func toObject<T: Codable>(_ param: T) -> T? {
        do {
            let data = (self as AnyObject).data(using: String.Encoding.utf8.rawValue)
            let obj = try JSONDecoder().decode(T.self, from: data!)
            return obj
        } catch {
            print("解析出错啦：\(error)")
            return nil
        }
    }

    /// 类文件字符串转换为ViewController
    ///
    /// - Parameter childControllerName: VC的字符串
    /// - Returns: ViewController
    func swiftClass() -> NSObject? {
        // 1.获取命名空间
        // 通过字典的键来取值,如果键名不存在,那么取出来的值有可能就为没值.所以通过字典取出的值的类型为AnyObject?
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("命名空间不存在")
            return nil
        }
        // 2.通过命名空间和类名转换成类
//        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + self)
        let cls : AnyClass? = NSClassFromString(self)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? NSObject.Type else {
            print("无法转换成UIViewController")
            return nil
        }
        // 3.通过Class创建对象
        let childController = clsType.init()
        return childController
    }
}

