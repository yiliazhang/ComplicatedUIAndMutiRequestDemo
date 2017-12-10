//
//  V2EXSettings.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/24/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

let keyPrefix =  "com.yilia."

class YILSettings: NSObject {
    static let shared = YILSettings()
    fileprivate override init(){
        super.init()
    }
    
    class func encodeBase64(string: String) -> String {
        guard let data = string.data(using: String.Encoding.utf8) else {
            return ""
        }
        
        return data.base64EncodedString(options: .lineLength64Characters)
    }
    
    class func decodeBase64(string: String) -> String {
        guard let data = NSData(base64Encoded: string, options: .ignoreUnknownCharacters) else {
            return ""
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)!
    }
    
    subscript(key:String) -> String? {
        get {
            if let result =  UserDefaults.standard.object(forKey: keyPrefix + key) as? String,
                !result.isEmpty {
                return YILSettings.decodeBase64(string: result)
            } else {
                return nil
            }
        }
        set {
            let myKey = keyPrefix + key
            if let valueOne = newValue,
                !valueOne.isEmpty {
                UserDefaults.standard.setValue(YILSettings.encodeBase64(string: valueOne), forKey: myKey)
            } else {
                UserDefaults.setNilValueForKey(myKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
}
