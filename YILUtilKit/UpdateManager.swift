//
//  UpdateManager.swift
//  MOSP
//
//  Created by apple on 2017/12/1.
//

import Foundation
import UIKit
struct UpdateManager {
    static func update(_ appName: String) {
        let params = ["appName": appName, "deviceType": "0"]
        NetworkHelper.actionJSON("servlet/appservlet/settingManage/GET_APPVERSION_INFO", params: params) { (response) in
            guard response.resultCode == .success else {
                return
            }

            guard let json = response.value else {
                return
            }
            guard let description = json["versionDesc"].string,
                !description.isEmpty else {
                return
            }

            guard let version = json["version"].string,
                !version.isEmpty else {
                return
            }

            guard let url = json["updateURL"].string,
                !url.isEmpty else {
                return
            }
            UpdateManager.checkUpdate(url, remoteVersion: version, description: description)
        }
    }

    static func checkUpdate(_ forURL: String, remoteVersion: String = "1", description: String = "") {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        var needUpdate = false
        if currentVersion.compare(remoteVersion) == ComparisonResult.orderedDescending {
            needUpdate = true
        }

        if needUpdate {
            if let url = URL(string: forURL) {
                let title = "提示"
                let message: String = description
                let cancelButtonTitle = NSLocalizedString("取消", comment: "")
                let otherButtonTitle = NSLocalizedString("更新", comment: "")
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                // Create the actions.
                let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
                let otherAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                })
                // Add the actions.
                alertController.addAction(cancelAction)
                alertController.addAction(otherAction)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 3), execute: {
                    UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
}
