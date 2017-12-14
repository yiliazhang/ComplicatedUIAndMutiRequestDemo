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

final class CollectionManager: SectionTypable {
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
    public var request: TargetType  = Home.none

    var sectionController: () -> ListSectionController

    init(_ identifier: String, request: TargetType = Home.none, startRequest: Bool = true, sectionController: @escaping () -> ListSectionController) {
        self.identifier = identifier
        self.request = request
        self.sectionController = sectionController
        self.startRequest = startRequest
        if !self.startRequest {
            completion(self)
            return
        }
        /// 重新创建一个模型和我的所有属性相同（以后想想能否通过实现 NSCopy 来优化）
        /// startRequest 设置为 false,防止重复循环请求，陷入死循环
        let myNewItem = CollectionManager(self.identifier,request: self.request, startRequest: false, sectionController: self.sectionController)
        provider.request(MultiTarget(request)) { (result) in
            do {
                let response = try result.dematerialize()
                let value = try response.mapNSArray()
                myNewItem.items = value as! [ListDiffable]
                if let listManager = ManagerCenter.shared[self.listManagerIdentifier],
                    listManager.itemIdentifiers.contains(self.identifier) {
                    //重新注册，替换原来的对应元素
                    listManager.register(myNewItem)
                }
            } catch {
                self.completion(self)
            }
        }
    }
}

