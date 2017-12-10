//
//  V2ProgressHUD.swift
//  V2ex-Swift
//
//  Created by skyline on 16/3/29.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit
import KRProgressHUD
import SwiftMessages
struct ProgressHUD {
    static let font = UIFont.systemFont(ofSize: 14)
    public static func show() {
        KRProgressHUD.show()
    }
    
    public static func dismiss() {
        KRProgressHUD.dismiss()
        if #available(iOS 9.0, *) {
        } else {
            
        }
    }
    
    public static func showWithStatus(_ status:String!) {
        KRProgressHUD.showInfo(withMessage: status)
        if #available(iOS 9.0, *) {
        } else {
            
        }
    }
    
    public static func success(_ status:String!) {
        KRProgressHUD.showSuccess(withMessage: status)
        
        if #available(iOS 9.0, *) {
        } else {
            
        }
    }
    
    public static func error(_ status:String!) {
        KRProgressHUD.showError(withMessage: status)
        
        if #available(iOS 9.0, *) {
        } else {
            
        }
    }
    
    public static func info(_ status:String!) {
        KRProgressHUD.showInfo(withMessage: status)
        if #available(iOS 9.0, *) {
        } else {
            
        }
    }
}

extension YIL {
    public class func hudSuccess(_ status:String!) {
        ProgressHUD.success(status)
    }

    public class func hudError(_ status:String!) {
        ProgressHUD.error(status)
    }

    public class func hudInfo(_ status:String!) {
        ProgressHUD.info(status)
    }

    public class func hudBeginLoading() {
        ProgressHUD.show()
    }

    public class func hudBeginLoadingWithStatus(_ status:String!) {
        ProgressHUD.showWithStatus(status)
    }

    public class func yil_hudEndLoading() {
        ProgressHUD.dismiss()
    }
}


fileprivate func makeMessageView(title: String = "", message: String = "") -> MessageView {
    let view = MessageView.viewFromNib(layout: .statusLine)
    view.configureContent(title: "", body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
    view.configureTheme(.info, iconStyle: .default)
    view.button?.isHidden = true
    view.iconImageView?.isHidden = true
    view.iconLabel?.isHidden = true
    view.titleLabel?.isHidden = true
    return view
}

fileprivate func makeConfig() -> SwiftMessages.Config {
    var config = SwiftMessages.Config()
    config.presentationStyle = .top
    config.presentationContext = .automatic
    config.duration = .seconds(seconds: 1)
    //    config.dimMode = .gray(interactive: false)
    config.preferredStatusBarStyle = .lightContent
    return config
}

extension YIL where Base: UIViewController {
    public func toastSuccess(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.success)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
    
    public func toastError(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.error)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
    
    public func toastInfo(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.info)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
    
    public func toastWarning(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.warning)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
}

extension YIL where Base: UIView {
    public func toastSuccess(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.success)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
    
    public func toastError(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.error)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
    
    public func toastInfo(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.info)
        
        SwiftMessages.show(config: makeConfig(), view: view)
    }
    
    public func toastWarning(_ status:String!) {
        let view = makeMessageView( message: status)
        view.configureTheme(.warning)
        SwiftMessages.show(config: makeConfig(), view: view)
    }
}
