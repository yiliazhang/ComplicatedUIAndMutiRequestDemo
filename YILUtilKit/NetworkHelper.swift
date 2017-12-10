//
//  NetworkHelper.swift
//  TJMobile
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 yilia. All rights reserved.
//
/**
 ## Feature Support

 This class does some awesome things. It supports:

 - Feature 1
 - Feature 2
 - Feature 3

 ## Examples

 Here is an example use case indented by four spaces because that indicates a
 code block:

 let myAwesomeThing = MyAwesomeClass()
 myAwesomeThing.makeMoney()

 ## Warnings

 There are some things you should be careful of:

 1. Thing one
 2. Thing two
 3. Thing three
 */
import Foundation
import Alamofire
import SwiftyJSON
typealias YILJSON = JSON

enum ResultCode: Int {
    case failure = 1
    case success = 0
    case tokenInvalid = -1
}

class YILResponse: NSObject {
    var resultCode = ResultCode.failure
    var message = ""

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - resultCode: <#resultCode description#>
    ///   - message: <#message description#>
    init(resultCode: ResultCode = ResultCode.failure, message: String = "") {
        super.init()
        self.resultCode = resultCode
        self.message = message
    }

    init(resultCode: ResultCode = ResultCode.failure) {
        super.init()
        self.resultCode = resultCode
    }
}



class YILJSONResponse: YILResponse {
    var value:YILJSON?
    convenience init(value:YILJSON, resultCode: ResultCode = ResultCode.failure) {
        self.init(resultCode: resultCode)
        self.value = value
    }

    convenience init(value:YILJSON, resultCode: ResultCode = ResultCode.failure, message: String = "") {
        self.init(value: value, resultCode: resultCode)
        self.message = message
    }
}


class YILValueResponse<T: Codable>: YILResponse {
    var value: T?

    convenience init(value: T, resultCode: ResultCode = ResultCode.failure) {
        self.init(resultCode: resultCode)
        self.value = value
    }
    
    convenience init(value: T, resultCode: ResultCode = ResultCode.failure, message: String = "") {
        self.init(value: value, resultCode: resultCode)
            self.message = message
    }
}

/**

/// 主机地址
var host: String! {
    let userDefault = UserDefaults.standard
    if let tmpHost = userDefault.string(forKey: kHost) {
        return "http://" + tmpHost + ":" + port + "/interface/"
    } else {
        return "http://www.baidu.com"
    }
}
*/

/**
/// 端口号
var port: String! {
    let userDefault = UserDefaults.standard
    if let port = userDefault.string(forKey: kPort) {
        return port
    } else {
        return "8080"
    }
}

*/

fileprivate let kResultBody = "resultBody"
fileprivate let kResultCode = "resultCode"

fileprivate let kContent = "responseBody"
fileprivate let kStatusCode = "returnCode"
fileprivate let kMessage = "resultInfo"

//fileprivate let kParams = "params"

/// MARK: 私有静态属性
fileprivate var cache = NSCache<AnyObject,AnyObject>()
fileprivate var uuid: String! {
    let userDefault = UserDefaults.standard
    return userDefault.string(forKey: "uuId")
}

/// <#Description#>
///
/// - Parameter initialString: <#initialString description#>
/// - Returns: <#return value description#>
fileprivate func nonLossyASCIIString(_ initialString: String) -> String {
    var toString = initialString
    if let utf8String = initialString.cString(using: .utf8) {
        if let oneString = String(cString: utf8String, encoding: .nonLossyASCII) {
            toString = oneString
        }
    }
    return toString
}

@objc protocol Flier {
    @objc optional var song : String {get}
    @objc optional var song2 : String {get set}
    @objc optional func sing()
    @objc optional func sing2() -> String
}

struct NetworkHelper {
    /// token 失效时会调用的
    static var authorizeFailed :(() -> Void)?

    static func failureJson(_ errorMessage: String) -> [AnyHashable : Any] {
        return [kResultCode: ResultCode.failure.rawValue,
                kResultBody: [kMessage: errorMessage,
                              kStatusCode: ResultCode.failure.rawValue]]
    }

    static private func ala_cachedPost<T: Codable>(url: String,
                                                params: [String:Any] = [:],
                                                showHUD: Bool = false,
                                                completion: @escaping ((YILValueResponse<T>) -> Void ) = {_ in }) {
        if showHUD {
            ProgressHUD.show()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var newKey = url
        if !params.isEmpty {
            newKey += params.description
        }
        let cacheData = cache.object(forKey: newKey as AnyObject) as? NSPurgeableData
        if let cacheData = cacheData {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if showHUD {
                //            yil_mainQueue {
                ProgressHUD.dismiss()
                //            }
            }
            cacheData.beginContentAccess()
            //把Data对象转换回JSON对象
            do {
                let response = try JSONSerialization.jsonObject(with: cacheData as Data,
                                                                options:.allowFragments) as! [AnyHashable: Any]
                YILLog.info("url: " + url)
                YILLog.info("params: " + params.description)
                YILLog.info("response: " + nonLossyASCIIString(response.description))
                NetworkHelper.dealOne(response: response, completion: completion)
            } catch {
                YILLog.warning(url + "-->" + params.description + "-->" + "缓存数据不存在")
            }
            cacheData.endContentAccess()
        } else {
            var error: String!
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if showHUD {
                    //                yil_mainQueue {
                    ProgressHUD.dismiss()
                    //                }
                }

                var json: [AnyHashable: Any]
                if response.error != nil {
                    error = response.error!.localizedDescription
                    json = NetworkHelper.failureJson(error)
                } else {
                    guard let tmpJSON: [AnyHashable: Any] = response.result.value as? [String : AnyObject] else {
                        error = "返回不是json字符串"
                        assertionFailure(error!)
                        return
                    }
                    json = tmpJSON
                }
                //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
                if let data = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    let cachedData = NSPurgeableData(data: data)
                    cache.setObject(cachedData, forKey: newKey as AnyObject)
                    cachedData.endContentAccess();
                }
                YILLog.info("url: " + url)
                YILLog.info("params: " + params.description)
                YILLog.info("response: " + nonLossyASCIIString(response.description))
                NetworkHelper.dealOne(response: json, completion: completion)
            }
        }
    }

    static private func ala_post<T: Codable>(url: String,
                                          params: [String:Any] = [:],
                                          showHUD: Bool = false,
                                          completion: @escaping ((YILValueResponse<T>) -> Void ) = { _ in }) {
        if showHUD {
            ProgressHUD.show()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var error: String!
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if showHUD {
                ProgressHUD.dismiss()
            }
            var json: [AnyHashable: Any]
            if response.error != nil {
                error = response.error!.localizedDescription
                json = NetworkHelper.failureJson(error)
            } else {
                guard let tmpJSON: [AnyHashable: Any] = response.result.value as? [String : AnyObject] else {
                    error = "返回不是json字符串"
                    assertionFailure(error!)
                    return
                }
                json = tmpJSON
            }
            YILLog.info("url: " + url)
            YILLog.info("params: " + params.description)
            YILLog.info("response: " + nonLossyASCIIString(response.description))
            NetworkHelper.dealOne(response: json, completion: completion)
        }
    }

    static private func dealOne<T: Codable>(response: [AnyHashable: Any], completion: ((YILValueResponse<T>) -> Void ) = { _ in }) {
        let codeOne = response[kResultCode] as! Int
        assert(ResultCode(rawValue: codeOne) != nil, "未知返回状态")
        let resultCode = ResultCode(rawValue: codeOne) ?? .failure
        var responseValue: YILValueResponse<T>!
        if resultCode == .tokenInvalid {
            yil_mainQueue {
                UIApplication.shared.delegate?.window??.yil.toastWarning("token 失效,请重新登陆")
            }
            if let block = NetworkHelper.authorizeFailed {
                block()
            }
            responseValue = YILValueResponse(resultCode: resultCode)
        } else if resultCode == .success {
            if let body = response[kResultBody] as? [AnyHashable: Any] {
                let codeTwo = body[kStatusCode] as! Int
                assert((ResultCode(rawValue: codeTwo) != nil), "未知返回状态")
                let resultCodeTwo = ResultCode(rawValue: codeTwo) ?? resultCode
                if resultCodeTwo == .tokenInvalid {
                    yil_mainQueue {
                        UIApplication.shared.delegate?.window??.yil.toastWarning("token 失效,请重新登陆")
                    }
                    if let block = NetworkHelper.authorizeFailed {
                        block()
                    }
                } else if resultCodeTwo == .success {
                    do {
                        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
                        let data = try JSONSerialization.data(withJSONObject: body, options: [])
                        let obj = try JSONDecoder().decode(T.self, from: data)
                        responseValue = YILValueResponse(value: obj, resultCode: resultCodeTwo)
                    } catch {
                        assertionFailure("对象解析出错,可能返回类型和对应类型属性不一致，如 String 被定义了 Int 型")
                        responseValue = YILValueResponse(resultCode: resultCodeTwo)
                    }
                } else if resultCodeTwo == .failure {
                    if let errorMessage = response[kMessage] as? String {
                        yil_mainQueue {
                            UIApplication.shared.delegate?.window??.yil.toastWarning(errorMessage)
                        }
                        responseValue = YILValueResponse(resultCode: resultCodeTwo, message: errorMessage)
                    } else {
                        responseValue = YILValueResponse(resultCode: resultCodeTwo)
                    }
                }
            } else {
                ///不存在 resultBody
                responseValue = YILValueResponse(resultCode: resultCode)
            }
        } else if resultCode == .failure {
            responseValue = YILValueResponse(resultCode: resultCode)
        }
        yil_mainQueue {
            completion(responseValue)
        }
    }

    static private func deal<T: Codable>(response: [AnyHashable: Any], completion: ((YILValueResponse<T>) -> Void ) = { _ in }) {
        let codeOne = response[kStatusCode] as! NSNumber
        let resultCode = ResultCode(rawValue: codeOne.intValue)
        assert((resultCode != nil), "未知返回状态")
        var responseValue: YILValueResponse<T>!
        if resultCode == .tokenInvalid {
            yil_mainQueue {
                UIApplication.shared.delegate?.window??.yil.toastWarning("token 失效,请重新登陆")
            }
            if let block = NetworkHelper.authorizeFailed {
                block()
            }
            responseValue = YILValueResponse(resultCode: resultCode!)
        } else if resultCode == .success {
            if let tmpResponse = response[kContent] {
                //            guard let jsonObject = YILJSON(rawValue: tmpResponse) else {
                //                assert(false, "返回数据不正确")
                //                return
                //            }
                let data = (tmpResponse as AnyObject).data(using: String.Encoding.utf8.rawValue)
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data!)
                    responseValue = YILValueResponse(value: obj, resultCode: resultCode!)
                } catch {
                    print("出错啦：\(error)")
                    responseValue = YILValueResponse(resultCode: resultCode!)
                }
            } else {
                responseValue = YILValueResponse(resultCode: resultCode!)
            }
        } else if resultCode == .failure {
            if let errorMessage = response[kMessage] as? String {
                yil_mainQueue {
                    UIApplication.shared.delegate?.window??.yil.toastWarning(errorMessage)
                }
                responseValue = YILValueResponse(resultCode: resultCode!, message: errorMessage)
            } else {
                responseValue = YILValueResponse(resultCode: resultCode!)
            }
        }
        yil_mainQueue {
            completion(responseValue)
        }
    }

    static func actionCodable<T: Codable>(_ action: String, params: CustomStringConvertible = "", cache: Bool = false, showHUD: Bool = false,completion: (@escaping (YILValueResponse<T>) -> Void) = { _ in }) {
        let url = HostManager.baseURL + action
        //    var myParams: [String:Any] = ["uuId": uuid ?? ""]
        var myParams: [String:Any] = [ "ak": "test"]

        if params.description.count > 0 {
            let paramsOne = params as! [String : Any]
            for (key, value) in paramsOne {
                myParams[key] = value
            }
        }
        if cache {
            var cacheKey = action
            if params.description.count > 0 {
                cacheKey = cacheKey.appending(params.description)
            }
            NetworkHelper.ala_cachedPost(url: url, params: myParams, showHUD: showHUD, completion: completion)
        } else {
            NetworkHelper.ala_post(url: url, params: myParams, showHUD: showHUD, completion: completion)
        }
    }
}

//MARK: - JSON Response
extension NetworkHelper {
    static private func ala_postCachedJSON(url: String,
                                                   params: [String:Any] = [:],
                                                   showHUD: Bool = false,
                                                   completion: @escaping ((YILJSONResponse) -> Void ) = {_ in }) {
        if showHUD {
            ProgressHUD.show()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var newKey = url
        if !params.isEmpty {
            newKey += params.description
        }
        let cacheData = cache.object(forKey: newKey as AnyObject) as? NSPurgeableData
        if let cacheData = cacheData {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if showHUD {
                //            yil_mainQueue {
                ProgressHUD.dismiss()
                //            }
            }
            cacheData.beginContentAccess()
            //把Data对象转换回JSON对象
            do {
                let response = try JSONSerialization.jsonObject(with: cacheData as Data,
                                                                options:.allowFragments) as! [AnyHashable: Any]
                YILLog.info("url: " + url)
                YILLog.info("params: " + params.description)
                YILLog.info("response: " + nonLossyASCIIString(response.description))
                NetworkHelper.dealOneJSON(response: response, completion: completion)
            } catch {
                YILLog.warning(url + "-->" + params.description + "-->" + "缓存数据不存在")
            }
            cacheData.endContentAccess()
        } else {
            var error: String!
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if showHUD {
                    //                yil_mainQueue {
                    ProgressHUD.dismiss()
                    //                }
                }

                var json: [AnyHashable: Any]
                if response.error != nil {
                    error = response.error!.localizedDescription
                    json = NetworkHelper.failureJson(error)
                } else {
                    guard let tmpJSON: [AnyHashable: Any] = response.result.value as? [String : AnyObject] else {
                        error = "返回不是json字符串"
                        assertionFailure(error!)
                        return
                    }
                    json = tmpJSON
                }
                //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
                if let data = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    let cachedData = NSPurgeableData(data: data)
                    cache.setObject(cachedData, forKey: newKey as AnyObject)
                    cachedData.endContentAccess();
                }
                YILLog.info("url: " + url)
                YILLog.info("params: " + params.description)
                YILLog.info("response: " + nonLossyASCIIString(response.description))
                NetworkHelper.dealOneJSON(response: json, completion: completion)
            }
        }
    }

    static private func ala_postJSON(url: String,
                                             params: [String:Any] = [:],
                                             showHUD: Bool = false,
                                             completion: @escaping ((YILJSONResponse) -> Void ) = { _ in }) {
        if showHUD {
            ProgressHUD.show()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var error: String!
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if showHUD {
                //            yil_mainQueue {
                ProgressHUD.dismiss()
                //            }
            }
            var json: [AnyHashable: Any]
            if response.error != nil {
                error = response.error!.localizedDescription
                json = NetworkHelper.failureJson(error)

            } else {
                guard let tmpJSON: [AnyHashable: Any] = response.result.value as? [String : AnyObject] else {
                    error = "返回不是json字符串"
                    assertionFailure(error!)
                    return
                }
                json = tmpJSON
            }
            YILLog.info("url: " + url)
            YILLog.info("params: " + params.description)
            YILLog.info("response: " + nonLossyASCIIString(response.description))
            NetworkHelper.dealOneJSON(response: json, completion: completion)
        }
    }

    static private func dealOneJSON(response: [AnyHashable: Any], completion: ((YILJSONResponse) -> Void ) = { _ in }) {
        let codeOne = response[kResultCode] as! NSNumber
        assert((ResultCode(rawValue: codeOne.intValue) != nil), "未知返回状态")
        let resultCode = ResultCode(rawValue: codeOne.intValue) ?? .failure
        var responseValue = YILJSONResponse(resultCode: resultCode)
        if resultCode == .tokenInvalid {
            yil_mainQueue {
                UIApplication.shared.delegate?.window??.yil.toastWarning("token 失效,请重新登陆")
            }
            if let block = NetworkHelper.authorizeFailed {
                block()
            }
            responseValue = YILJSONResponse(resultCode: resultCode)
        } else if resultCode == .success {
            if let body = response[kResultBody],
                let jsonObject = YILJSON(rawValue: body) {
                let codeTwo = jsonObject.dictionaryValue[kStatusCode]?.intValue ?? resultCode.rawValue
                assert((ResultCode(rawValue: codeTwo) != nil), "未知返回状态")
                let resultCodeTwo = ResultCode(rawValue: codeTwo) ?? resultCode
                responseValue = YILJSONResponse(value: jsonObject, resultCode: resultCodeTwo)
            } else {
                responseValue = YILJSONResponse(resultCode: resultCode)
            }
        } else if resultCode == .failure {
            if let errorMessage = response[kMessage] as? String {
                yil_mainQueue {
                    UIApplication.shared.delegate?.window??.yil.toastWarning(errorMessage)
                }
                responseValue = YILJSONResponse(resultCode: resultCode, message: errorMessage)
            }
        }
        yil_mainQueue {
            completion(responseValue)
        }
    }

    static private func dealJSON(response: [AnyHashable: Any], completion: ((YILJSONResponse) -> Void ) = { _ in }) {
        let codeOne = response[kStatusCode] as! Int
        let codeTwo = ResultCode(rawValue: codeOne)
        assert((codeTwo != nil), "未知返回状态")
        let resultCode = codeTwo ?? ResultCode.failure
        var responseValue = YILJSONResponse(resultCode: resultCode)
        if resultCode == .tokenInvalid {
            yil_mainQueue {
                UIApplication.shared.delegate?.window??.yil.toastWarning("token 失效,请重新登陆")
            }
            if let block = NetworkHelper.authorizeFailed {
                block()
            }
            responseValue = YILJSONResponse(resultCode: resultCode)
        } else if resultCode == .success {
            if let tmpResponse = response[kContent],
                let jsonObject = YILJSON(rawValue: tmpResponse) {
                    responseValue = YILJSONResponse(value: jsonObject, resultCode: resultCode)

            } else {
                responseValue = YILJSONResponse(resultCode: resultCode)
            }
        } else if resultCode == .failure {
            if let errorMessage = response[kMessage] as? String {
                yil_mainQueue {
                    UIApplication.shared.delegate?.window??.yil.toastWarning(errorMessage)
                }
                responseValue = YILJSONResponse(resultCode: resultCode, message: errorMessage)
            }
        }
        yil_mainQueue {
            completion(responseValue)
        }
    }

    static func actionJSON(_ action: String, params: CustomStringConvertible = "", cache: Bool = false, showHUD: Bool = false,completion: (@escaping (YILJSONResponse) -> Void) = { _ in }) {
        let url = HostManager.baseURL + action
        //    var myParams: [String:Any] = ["uuId": uuid ?? ""]
        var myParams: [String : Any] = ["ak" : "test"]

        if params.description.count > 0 {
            let paramsOne = params as! [String : Any]
            for (key, value) in paramsOne {
                myParams[key] = value
            }
        }
        if cache {
            var cacheKey = action
            if params.description.count > 0 {
                cacheKey = cacheKey.appending(params.description)
            }
            NetworkHelper.ala_postCachedJSON(url: url, params: myParams, showHUD: showHUD, completion: completion)
        } else {
            NetworkHelper.ala_postJSON(url: url, params: myParams, showHUD: showHUD, completion: completion)
        }
    }
}
