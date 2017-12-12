//
//  DemoItem.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

// MARK: - Demo Data

func demoGridItems() -> [ListDiffable] {
    return [GridItem(imageName: "icon_zsk", title: "\(arc4random()%999 + arc4random()%9999)"),
            GridItem(imageName: "icon_wghyw", title: "\(arc4random()%999 + arc4random()%9999)"),
            GridItem(imageName: "icon_daka", title: "\(arc4random()%999 + arc4random()%9999)"),
            GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)")] as [ListDiffable]
}

func demoStrings() -> [ListDiffable] {
    var index = arc4random()%10
    var tmpItems: [String] = []
    while (index > 0) {
        index = index - 1
        let value = "\(arc4random()%999 + arc4random()%9999)"
        if !tmpItems.contains(value) {
            tmpItems.append(value)
        }
    }
    return tmpItems as [ListDiffable]
}

func demoImageURLs() -> [ListDiffable] {
    var tmpItems: [String] = []
    var index = arc4random()%10
    while index > 0 {
        index = index - 1
        let width = Int(arc4random() % 300) + 20
        let height = Int(arc4random() % 100) + 200
        tmpItems.append("https://unsplash.it/" + width.description + "/" + height.description)
    }
    return tmpItems as [ListDiffable]
}

// MARK: - DemoItem

final class DemoItem: NSObject {
    var completion: ((DemoItem) -> Void) = { _ in }
    var items: [ListDiffable] = []
    var listManagerIdentifier: String = ""
    var identifier: String = ""
    var request: Home = .none
    var sectionControllerName: String = ListSectionController.description()
    weak var delegate: UpdateData?
    init(_ identifier: String, sectionControllerName: String, request: Home = .none,completion: @escaping ((DemoItem) -> Void) = { _ in }) {
        super.init()
        self.identifier = identifier
        self.sectionControllerName = sectionControllerName
        self.completion = completion
        self.request = request
        if self.request == .none {
            return
        }
        homeProvider.request(request) { (result) in

            let myNewItem = DemoItem(self.identifier, sectionControllerName: self.sectionControllerName)
            //TODO: - 数据转换
            switch request {
            case .gridItem:
                myNewItem.items = demoGridItems()
            case .text:
                myNewItem.items = demoStrings()
            case .centerText:
                myNewItem.items = demoStrings()
            case .image:
                myNewItem.items = demoImageURLs()
            default:
                break
            }
            if let listManager = ManagerCenter.shared[self.listManagerIdentifier] {
                if listManager.itemIdentifiers.contains(myNewItem.identifier) {
                    listManager.register(myNewItem)
                }
            }

            self.completion(myNewItem)
        }
    }
}

extension DemoItem: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard (object as? DemoItem) != nil else { return false }
        return true
    }
}


