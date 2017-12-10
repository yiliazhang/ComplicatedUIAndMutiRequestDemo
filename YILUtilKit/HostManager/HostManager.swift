//
//  HostManager.swift
//  MOSP
//
//  Created by apple on 2017/11/30.
//

import Foundation
@objcMembers class HostManager: NSObject {
    struct Constrants {
        static let myHost = "com.mosp.host"
        static let myPort = "com.mosp.port"

    }

    class var baseURL: String {
        if let tmpHost = HostManager.host,
            !tmpHost.isEmpty,
            let tmpPort = HostManager.port,
            !tmpPort.isEmpty {
            return "http://" + tmpHost + ":" + tmpPort + "/interface/"
        } else {
            assertionFailure("host 为空 或 port 为空")
            return "http://218.90.150.118:1080/interface/"
        }
    }

    /// 主机地址
    class var host: String? {
        get {
            return YILSettings.shared[Constrants.myHost]
        }
        set(newValue) {
            YILSettings.shared[Constrants.myHost] = newValue ?? nil
        }
    }

    /// 端口
    class var port: String? {
        get {
            return YILSettings.shared[Constrants.myPort]
        }
        set(newValue) {
            YILSettings.shared[Constrants.myPort] = newValue ?? nil
        }
    }
}
