//
//  V2User.swift
//  V2ex-Swift
//
//  Created by skyline on 16/3/28.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

@objcMembers class UserManager: NSObject {
    static let shared = UserManager()
    /// 用户信息
    private var _currentUser:User?
    dynamic var currentUser: User? {
        get {
            return _currentUser
        }
        set {
            //保证给user赋值是在主线程进行的
            //原因是 有很多UI可能会监听这个属性，这个属性发生更改时，那些UI也会相应的修改自己，所以要在主线程操作
            yil_mainQueue {
                _currentUser = newValue
            }
        }
    }

    // MARK: 当前车辆状况
    ///
    fileprivate var  _currentLocation: CLLocation?
    
    @objc dynamic var currentLocation: CLLocation? {
        get {
            return _currentLocation
        }
        
        set {
             _currentLocation = newValue
        }
    }

    fileprivate var _once:String?
    //全局once字符串，用于用户各种操作，例如回帖 登录 。这些操作都需要用的once ，而且这个once是全局统一的
    var once:String?  {
        get {
            //取了之后就删掉,
            //因为once 只能使用一次，之后就不可再用了，
            let onceStr = _once
            _once = nil
            return onceStr;
        }
        set{
            _once = newValue
        }
    }

    /// 返回 客户端显示是否有可用的once
    var hasOnce:Bool {
        get {
            return _once?.count > 0
        }
    }

    /// 通知数量
    @objc dynamic var notificationCount:Int = 0

    fileprivate override init() {
        super.init()
        yil_mainQueue {
            setup()
            //如果客户端是登录状态，则去验证一下登录有没有过期
            if isLogin {
                verifyLoginStatus()
            }
        }
    }
    
    func setup(){
    }


    /// 是否登录
    var isLogin:Bool {
        get {
            if currentUser == nil {
                return true
            } else {
                return false
            }
        }
    }

    func ensureLoginWithHandler(_ handler:()->()) {
        guard isLogin else {
            UIApplication.shared.keyWindow?.yil.toastWarning("请先登录")
            return;
        }
        handler()
    }

    /**
     退出登录
     */
    func loginOut() {
//        BPush.unbindChannel { (result, error) in
//            guard error == nil,
//                let newResult = result as? [AnyHashable: Any] else {
//                    return
//            }
//            // 确认解绑成功
//            guard let errorCode = newResult["error_code"] as? String,
//                let errorCodeOne = Int(errorCode),
//                errorCodeOne == 0 else {
//                    return
//            }
//        }
        removeAllCookies()
//        telephone = nil
        once = nil
        notificationCount = 0
        //清空settings中的username
        YILSettings.shared[kCurrentUser] = nil
        currentLocation = nil
        currentUser = nil
    }
    
    /**
     删除客户端所有缓存
     */
    func removeAllCaches() {
        // TODO: - 重新获取 用户 相应信息
    }
    /**
     删除客户端所有cookies
     */
    func removeAllCookies() {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
    }
    /**
     打印客户端cookies
     */
    func printAllCookies(){
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                NSLog("name:%@ , value:%@ \n", cookie.name,cookie.value)
            }
        }
    }

    /**
     获取once
     - parameter url:               有once存在的url
     */
//    func getOnce(_ url:String = host + "signin" , completionHandler: @escaping (YILResponse) -> Void) {
//        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml {
//            (response) -> Void in
//            if let jiHtml = response .result.value{
//                if let once = jiHtml.xPath("//*[@name='once'][1]")?.first?["value"]{
//                    self.once = once
//                    completionHandler(V2Response(success: true))
//                    return;
//                }
//            }
//            completionHandler(V2Response(success: false))
//        }
//    }

    /**
     获取并更新通知数量
     - parameter rootNode: 有Notifications 的节点
     */
//    func getNotificationsCount(_ rootNode: JiNode) {
//        //这里本想放在 JIHTMLResponseSerializer 自动获取。
//        //但我现在还不确定，是否每个每个页面的title都会带上 未读通知数量
//        //所以先交由 我确定会带的页面 手动获取
//        let notification = rootNode.xPath("//head/title").first?.content
//        if let notification = notification {
//
//            self.notificationCount = 0;
//
//            let regex = try! NSRegularExpression(pattern: "V2EX \\([0-9]+\\)", options: [.caseInsensitive])
//            regex.enumerateMatches(in: notification, options: [.withoutAnchoringBounds], range: NSMakeRange(0, notification.Lenght), using: { (result, flags, stop) -> Void in
//                if let result = result {
//                    let startIndex = notification.index(notification.startIndex, offsetBy: result.range.location + 6)
//                    let endIndex = notification.index(notification.startIndex, offsetBy: result.range.location + result.range.length - 1)
////                    let startIndex = notification.startIndex.advancedBy(result.range.location + 6)
////                    let endIndex = notification.startIndex.advancedBy(result.range.location + result.range.length - 1)
//                    let subRange = Range<String.Index>(startIndex ..< endIndex)
//                    let count = notification.substring(with: subRange)
//                    if let acount = Int(count) {
//                        self.notificationCount = acount
//                    }
//                }
//            })
//        }
//    }

    /**
     验证客户端登录状态

     - returns: ture: 正常登录 ,false: 登录过期，没登录
     */
    func verifyLoginStatus() {
//         Alamofire.request(host + "new", headers: MOBILE_CLIENT_HEADERS).responseString(encoding: nil) { (response) -> Void in
//            if response.request?.url?.absoluteString == response.response?.url?.absoluteString {
//                //登录正常
//            }
//            else{
//                //没有登录 ,注销客户端
//                dispatch_sync_safely_main_queue({ () -> () in
//                    self.loginOut()
//                })
//            }
//        }
    }
}
