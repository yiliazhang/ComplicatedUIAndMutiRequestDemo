//
//  HostConfig.swift
//  MOSP
//
//  Created by apple on 2017/12/1.
//

import Foundation
protocol HostProtocol {
    var updateName : String {get}
    var bundleID : String {get}
    var appKey : String {get set}
    func test()
    func testOne() -> Self
}

enum Host {
    case heBei

    ///  更新对应的 appName
    var updateName: String {
        switch self {
        case .heBei:
            return "HeBei"
        }
    }

    var bundleID: String {
        switch self {
        case .heBei:
            return "com.bjdv.HeBei.MOSP"
        }
    }

    /// 推送 appkey
    var appKey: String {
        switch self {
        case .heBei:
            return "54b437b16c13caa0539da30d"
        }
    }
    
}
