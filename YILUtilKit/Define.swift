//
//  V2ex+Define.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/11/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

let kCurrentUser = YILSettings.encodeBase64(string: "com.bjdv.Demo.currentUser.account")
let kUserPassword = YILSettings.encodeBase64(string: "com.bjdv.Demo.currentUser.password")
//let EMPTY_STRING = "" ;
/////屏幕宽度
//let screenWidth = UIScreen.main.bounds.size.width;
/////屏幕高度
//let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
//
/////keywindow
//let keyWindow = UIApplication.shared.keyWindow
////用户代理，使用这个切换是获取 m站点 还是www站数据
//let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
//let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]
//
/////系统版本
//let version = UIDevice.current.systemVersion

//站点地址,客户端只有https,禁用http
//let SEPARATOR_HEIGHT = 1.0 / UIScreen.main.scale


///国际化
func yil_localizedString( _ key:String ) -> String {
    return NSLocalizedString(key, comment: "")
}

///主线程
func yil_mainQueue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}

///系统字体
func yil_font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}

///延时执行
func yil_image(_ imageName: String) -> UIImage {
   let image = UIImage(named: imageName)
    assert((image != nil), "图片： " + imageName + "不存在")
    return image!
}

///延时执行
func yil_delay(_ delay:Double, closure:@escaping()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * delay )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        closure()
    }
}

///UIView 圆角
func yil_roundRectView<T: UIView>(_ view: T, radius: CGFloat = 0,borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
    var newRadius = radius
    if newRadius == 0 {
        newRadius = min(view.frame.size.width, view.frame.size.height) / 2
    }
    
    view.layer.cornerRadius = newRadius
    view.layer.borderWidth = borderWidth + 1
    view.layer.borderColor = borderColor.cgColor
    view.layer.masksToBounds = true
}

///UIView 设置阴影
func yil_shadowView<T: UIView>(_ view: T, shadowRadius: CGFloat = 0, offsetX: CGFloat = 0, offsetY: CGFloat = 0, color: UIColor = .clear, alpha: Float = 1.0) {
    view.layer.shadowColor = color.cgColor;
    view.layer.shadowOffset = CGSize(width:offsetX, height: offsetY);
    view.layer.shadowOpacity = alpha;
    view.layer.shadowRadius = shadowRadius
}


