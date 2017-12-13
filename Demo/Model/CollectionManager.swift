//
//  CollectionManager.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit
import Moya

// MARK: - CollectionManager

final class CollectionManager {
    var completion: ((CollectionManager) -> Void) = { _ in }
    var items: [ListDiffable] = []
    var listManagerIdentifier: String = ""
    var identifier: String = ""
    var startRequest = true
    public var request: Home = .none

    weak var delegate: UpdateData?
    init(_ identifier: String, request: Home = .none, startRequest: Bool = true, completion: @escaping (CollectionManager) -> Void = {_ in }) {
        self.identifier = identifier
        self.completion = completion
        self.request = request
        self.startRequest = startRequest
        if self.request == .none {
            self.startRequest = false
            return
        }
        if !self.startRequest {
            return
        }
        let myNewItem = CollectionManager(self.identifier,request: self.request, startRequest: false, completion: self.completion)
        homeProvider.request(request) { (result) in
            //TODO: - 数据转换
            switch request {
            case .gridItem:
                myNewItem.items = self.demoGridItems()
            case .text:
                myNewItem.items = self.demoStrings() as [ListDiffable]
            case .centerText:
                myNewItem.items = self.demoStrings() as [ListDiffable]
            case .image:
                myNewItem.items = self.demoImageURLs() as [ListDiffable]
            default:
                break
            }
            if let listManager = ManagerCenter.shared[self.listManagerIdentifier],
                listManager.itemIdentifiers.contains(self.identifier) {
                listManager.register(myNewItem)
//                self.completion(myNewItem)
            }
        }
    }
}

extension CollectionManager {

    // MARK: - Demo Data

    private func demoGridItems() -> [CollectionItem] {
        let items = [GridItem(imageName: "icon_zsk", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_wghyw", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_daka", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)")]
        return [CollectionItem(items)]
    }

    private func demoStrings() -> [String] {
        var index = arc4random()%10
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
        var index = arc4random()%10
        while index > 0 {
            index = index - 1
            let width = UIScreen.main.bounds.size.width
            let height = Int(arc4random() % 100) + 100
            tmpItems.append("https://unsplash.it/" + width.description + "/" + height.description)
        }
        return tmpItems
    }
}
