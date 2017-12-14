//
//  DataConvertModel.swift
//  Demo
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
import Moya
struct TransformToListDiffable {
    static func model(_ fromResponse: Moya.Response, targetType: TargetType) -> [ListDiffable] {
        switch targetType {
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
}

extension TransformToListDiffable {

    // MARK: - Demo Data

    static private func demoGridItems() -> [CollectionItem] {
        let items = [GridItem(imageName: "icon_zsk", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_wghyw", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_daka", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)"),]
        return [CollectionItem(items)]
    }

    static private func demoCenterStrings() -> [CollectionItem] {
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

    static private func demoStrings() -> [String] {
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

    static private func demoImageURLs() -> [String] {
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
}
