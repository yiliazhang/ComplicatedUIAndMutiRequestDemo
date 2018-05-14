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
        case .text:
            let name = "ashfurrow"

            return "/users/\(name.urlEscaped)/repos"
        default:
            return ""
        }
    }
    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        switch self {
//        case .text:
//            return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    public var validate: Bool {
        return false
    }
    public var sampleData: Data {
        switch self {
//        case .gridItem:
//            return "[{\"backgroundImageURL\": \"https://unsplash.it/100/100\",\"title\":\"\(arc4random()%999 + arc4random()%9999)\"},{\"backgroundImageURL\": \"https://unsplash.it/200/200\",\"title\":\"\(arc4random()%999 + arc4random()%9999)\"},{\"backgroundImageURL\": \"https://unsplash.it/50/50\",\"title\":\"\(arc4random()%999 + arc4random()%9999)\"},{\"backgroundImageURL\": \"https://unsplash.it/80/80\",\"title\":\"\(arc4random()%999 + arc4random()%9999)\"}]".data(using: String.Encoding.utf8)!
        case .text:
//            var index = 8
//            var items: [String] = []
//            while index > 0 {
//                index = index - 1
//                items.append("\(arc4random()%999 + arc4random()%9999)")
//            }
//
//            do {
//                return try JSONSerialization.data(withJSONObject: items, options: [])
//            } catch {
//                return Data()
//            }
            return "[\"Hello1\",\"Hello2\",\"Hello3\",\"Hello4\",\"Hello5\",\"Hello6\"]".data(using: String.Encoding.utf8)!
//        case .centerText:
//            return "[\"(arc4random()%999 + arc4random()%9999)\",\"\(arc4random()%999 + arc4random()%9999)","\(arc4random()%999 + arc4random()%9999)\",\"\(arc4random()%999 + arc4random()%9999)\",\"\(arc4random()%999 + arc4random()%9999)\"]".data(using: String.Encoding.utf8)!
//        case .image:
////            let width = UIScreen.main.bounds.size.width
////            let height = Int(arc4random() % 100) + 100
////            return "[\"https://unsplash.it/\(width)/\(Int(arc4random() % 100) + 100)\",\"https://unsplash.it/\(width)/\(Int(arc4random() % 100) + 100)\",\"https://unsplash.it/\(width)/\(Int(arc4random() % 100) + 100)\",\"https://unsplash.it/\(width)/\(Int(arc4random() % 100) + 100)\",\"https://unsplash.it/\(width)/\(Int(arc4random() % 100) + 100)\"]"
        default:
            return Data()
        }
    }
    public var headers: [String: String]? {
        return nil
    }
}

extension Home: TransformToListDiffable {
    func models(_ fromResponse: Moya.Response, targetType: TargetType) -> [ListDiffable] {
        switch self {
        case Home.centerText:
            return demoCenterStrings()
        case Home.text:
            return demoStrings() as [ListDiffable]
        case Home.image:
            return demoImageURLs() as [ListDiffable]
        case Home.gridItem:
            return demoGridItems()
        default:
            return []
        }
    }
    func model(_ fromResponse: Moya.Response, targetType: TargetType) -> ListDiffable {
        switch self {
        case Home.centerText:
            return demoCenterStrings().first!
        case Home.text:
            return demoStrings().first! as ListDiffable
        case Home.image:
            return demoImageURLs().first! as ListDiffable
        case Home.gridItem:
            return demoGridItems().first!
        default:
            return NSDate.description() as ListDiffable
        }
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




// MARK: - test data

// MARK: - Demo Data

private func demoGridItems() -> [CollectionItem] {
    let items = [GridItem(imageName: "icon_zsk", title: "\(arc4random()%999 + arc4random()%9999)"),
                 GridItem(imageName: "icon_wghyw", title: "\(arc4random()%999 + arc4random()%9999)"),
                 GridItem(imageName: "icon_daka", title: "\(arc4random()%999 + arc4random()%9999)"),
                 GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)"),]
    return [CollectionItem(items)]
}

private func demoCenterStrings() -> [CollectionItem] {
    var index = arc4random()%5 + 5
    var tmpItems: [String] = []
    while (index > 0) {
        index = index - 1
        let value = "\(arc4random()%999 + arc4random()%9999)"
        if !tmpItems.contains(value) {
            tmpItems.append(value)
        }
    }
    return [CollectionItem(tmpItems as [ListDiffable])]
}

private func demoStrings() -> [String] {
    var index = arc4random()%5 + 3
    var tmpItems: [String] = []
    while (index > 0) {
        index = index - 1
        let value = "\(arc4random()%999 + arc4random()%9999)"
        if !tmpItems.contains(value) {
            tmpItems.append(value)
        }
    }
    return tmpItems
}

private func demoImageURLs() -> [String] {
    var tmpItems: [String] = []
    var index = arc4random()%5 + 2
    while index > 0 {
        index = index - 1
        let width = UIScreen.main.bounds.size.width
        let height = Int(arc4random() % 100) + 100
        tmpItems.append("https://unsplash.it/" + width.description + "/" + height.description)
    }
    return tmpItems
}
