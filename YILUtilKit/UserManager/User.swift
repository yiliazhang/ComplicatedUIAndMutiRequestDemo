//
//  UserModel.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/23/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import CryptoSwift
import SwiftyJSON

/// 工区
class Area: Codable {
    private enum CodingKeys: CodingKey {
        case areaId
        case areaname
    }
    ///  工区名
    var areaName: String?

    /// 工区
    var areaID: String?

    //构造方法
    init(areaName: String, areaID: String) {
        self.areaName = areaName
        self.areaID = areaID
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(areaName, forKey: .areaname)
        try container.encode(areaID, forKey: .areaId)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)

        areaName = try container.decode(String.self, forKey: .areaname)
        areaID = try container.decode(String.self, forKey: .areaId)
    }
}


@objcMembers class User: NSObject, Codable {
    private enum CodingKeys: CodingKey {
        case area
        case staffId
        case staffName
    }

    /// 工区
    var area: Area?
    /// 手机保存的用户 登录名
    dynamic var loginID: String = ""
    /// 客服 系统数据库中的用户 ID  staffId = sysUserId
    dynamic var staffId: String = ""
    /// 客服 系统数据库中的用户 ID  staffId = sysUserId
    dynamic var staffName: String = ""
    /// 本系统数据库中的用户 ID staffId = sysUserId
    dynamic var sysUserId: String = ""
    /// 本系统数据库中的用户 ID staffId = sysUserId
    dynamic var sysUserName: String = ""
    /// 本系统密码
    dynamic var password: String = ""
    /// 机构名称
    dynamic var deptName: String = ""
    /// 电话号码
    dynamic var telephone: String = ""

    //构造方法
    init(area: Area, staffId: String, staffName: String) {

        self.area = area
        self.staffId = staffId
        self.staffName = staffName
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(staffId, forKey: .staffId)
        try container.encode(staffName, forKey: .staffName)
        try container.encode(area, forKey: .area)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)

        staffId = try container.decode(String.self, forKey: .staffId)
        staffName = try container.decode(String.self, forKey: .staffName)
        area = try container.decode(Area.self, forKey: .area)
    }

}

//MARK: - Request
extension User{
    // MARK: - 类方法
    
    /**
     登录

     - parameter username:          用户名
     - parameter password:          密码
     - parameter completionHandler: 登录回调
     */
    class func login(_ phoneNumber: String, password: String, autoLogin: Bool, rememberPassword: Bool,
                     completionHandler: @escaping (YILValueResponse<User>) -> Void
        ) {
        UserManager.shared.removeAllCookies()
        let params = ["userName": phoneNumber,
                      "passWord": password.md5()]
        NetworkHelper.actionCodable("servlet/appservlet/settingManage/LOGIN_AUTH", params: params) { (response: YILValueResponse<User>) in
            guard response.resultCode == .success else {
                completionHandler(response)
                return
            }

            guard let user = response.value else {
                completionHandler(response)
                return
            }
            user.loginID = phoneNumber
            UserManager.shared.currentUser = user
            //保存当前账号
            YILSettings.shared[kCurrentUser] = user.loginID
            YILSettings.shared[kUserPassword] = password
            completionHandler(YILValueResponse(resultCode: .success))
        }
    }

}
