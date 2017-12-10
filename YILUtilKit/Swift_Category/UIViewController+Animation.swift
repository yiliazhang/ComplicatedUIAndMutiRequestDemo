//
//  ViewController+Animation.swift
//  clw
//
//  Created by apple on 2016/10/13.
//  Copyright © 2016年 Datang. All rights reserved.
//

import UIKit
extension YIL where Base: UIViewController {
    ///动画替换 rootViewController
    func animate(toRootController controller: UIViewController) {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            assert(false, "参数错误")
            return
        }
        keyWindow.isUserInteractionEnabled = false
        //配置用户登录配置
        keyWindow.rootViewController = controller
        guard let myView = base.view else {
            return
        }
        controller.view.addSubview(myView)
        sleep(1)
        UIView.animate(withDuration: 0.5, delay: 0, animations: {[weak base] () -> Void in
            base?.view?.alpha = 0
            }, completion: {[weak base] (finished: Bool) -> Void in
                base?.view?.removeFromSuperview()
                keyWindow.isUserInteractionEnabled = true
        })

//        guard let window = UIApplication.shared.keyWindow else {
//            assert(false, "参数错误")
//            return
//        }
//        let image = UIImage.screenShot()
//        let imageView = UIImageView(image: image)
//        imageView.frame = UIScreen.main.bounds
//        controller.view.addSubview(imageView)
//        window.rootViewController = controller
//        UIView.animate(withDuration: 0.5, delay: 0, animations: {() -> Void in
//            imageView.alpha = 0
//        }, completion: {(finished: Bool) -> Void in
//            imageView.removeFromSuperview()
//        })
    }
    
    ///隐藏键盘
    func dismissKeyboard() {
        base.view.endEditing(true)
    }
}
