//
//  AppDelegate.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

class AppInitializer {
    ///应用启动设置
    class func logOut() {
        if let block = NetworkHelper.authorizeFailed {
            block()
        }
        //TODO: - 清理数据
    }

    /// 启动配置
    class func onAppStart() {
        IQKeyboardManager.sharedManager().enable = true
        UIApplication.shared.statusBarStyle = .lightContent

        /// appearance 设置
        UITabBarController.initializeOnce()
        UINavigationController.initializeOnce()

        /// token 失效处理
        NetworkHelper.authorizeFailed = {
            AppInitializer.clearUserData()
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: StackedViewController())
        }

        ///检测更新
//        UpdateManager.update(Host.heBei.updateName)
    }

    /// 清理缓存文件夹
    class func clearUserData() {
        YILSettings.shared[kCurrentUser] = nil
    }

    ///
    class func rootViewController() -> UIViewController {
        return UINavigationController(rootViewController: StackedViewController())
    }

    /// 网络请求测试
    class func test () {
        NetworkHelper.actionCodable("test", params: ["34": "12"]) { (response: YILValueResponse<User>) in
            print("hello codable")
        }

        NetworkHelper.actionJSON("test", params: ["34": "12"]) { (response) in
            print("hello json")
        }

        NetworkHelper.actionJSON("test", params: ["34": "12"])
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppInitializer.onAppStart()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppInitializer.rootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

