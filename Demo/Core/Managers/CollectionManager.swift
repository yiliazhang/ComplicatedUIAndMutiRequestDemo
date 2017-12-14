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
    /// 配置完成后需要做的事，目前没用到
    var completion: ((CollectionManager) -> Void) = { _ in }

    /// 包含的 元素
    var items: [ListDiffable] = []

    /// 我的ListManager 的唯一标识符
    var listManagerIdentifier: String = ""

    /// 我的唯一标识符
    var identifier: String = ""

    /// 是否启动请求数据
    var startRequest = true

    /// 请求类型
    public var request: Home = .none

    weak var delegate: UpdateData?

    var sectionController: () -> ListSectionController

    init(_ identifier: String, request: Home = .none, startRequest: Bool = true, sectionController: @escaping () -> ListSectionController) {
        self.identifier = identifier
        self.request = request
        self.sectionController = sectionController
        self.startRequest = startRequest

        if self.request == .none {
            self.startRequest = false
            completion(self)
            return
        }
        if !self.startRequest {
            completion(self)
            return
        }
        /// 重新创建一个模型和我的所有属性相同（以后想想能否通过实现 NSCopy 来优化）
        /// startRequest 设置为 false,防止重复循环请求，陷入死循环
        let myNewItem = CollectionManager(self.identifier,request: self.request, startRequest: false, sectionController: self.sectionController)
//        homeProvider.request(request) { (result) in
            DispatchQueue.global().async {
                semaphore.wait()
                sleep(arc4random()%8)
                semaphore.signal()
                DispatchQueue.main.sync {
            var tmpItems: [ListDiffable] = []
            //TODO: - 数据转换
            switch request {
            case .gridItem:
                tmpItems = self.demoGridItems()// 假数据
            case .text:
                tmpItems = self.demoStrings() as [ListDiffable]// 假数据
            case .centerText:
                tmpItems = self.demoCenterStrings()// 假数据
            case .image:
                tmpItems = self.demoImageURLs() as [ListDiffable]// 假数据
            default:
                break
            }
            myNewItem.items = tmpItems
            if let listManager = ManagerCenter.shared[self.listManagerIdentifier],
                listManager.itemIdentifiers.contains(self.identifier) {
                //重新注册，替换原来的对应元素
                listManager.register(myNewItem)
                self.completion(myNewItem)
            }
                }
            }
//        }
    }
}

// MARK: - 测试数据配置

extension CollectionManager {

    // MARK: - Demo Data

    private func demoGridItems() -> [CollectionItem] {
        let items = [GridItem(imageName: "icon_zsk", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_wghyw", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_daka", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)"),
                     GridItem(imageName: "icon_fjgl", title: "\(arc4random()%999 + arc4random()%9999)")]
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
}
