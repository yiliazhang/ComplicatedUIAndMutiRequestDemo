//
//  HomeAPI.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import Moya
import IGListKit
// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let homeProvider = MoyaProvider<Home>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum Home {
    case none
    case gridItem
    case text
    case centerText
    case image
}

extension Home: TargetType {
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
        case .gridItem:
            return "/zen"
        case .text:
            return "/text"
        case .centerText:
            return "/centerText"
        case .image:
            return "/images"
        default:
            return ""
        }
    }
    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        switch self {
        case .gridItem:
            return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    public var validate: Bool {
        switch self {
        case .gridItem:
            return false
        default:
            return true
        }
    }
    public var sampleData: Data {
//        switch self {
//        case .zen:
//            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
//        case .userProfile(let name):
//            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
//        case .userRepositories(let name):
//            return "[{\"name\": \"\(name)\"}]".data(using: String.Encoding.utf8)!
//        }
        switch self {
        case .gridItem:
            return "数据".data(using: String.Encoding.utf8)!
        case .text:
            return "数据".data(using: String.Encoding.utf8)!
        case .centerText:
            return "数据".data(using: String.Encoding.utf8)!
        case .image:
            return "数据".data(using: String.Encoding.utf8)!
        default:
            return Data()
        }
    }
    public var headers: [String: String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
