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

protocol TransformToListDiffable {
    func models(_ fromResponse: Moya.Response, targetType: TargetType) -> [ListDiffable]
    func model(_ fromResponse: Moya.Response, targetType: TargetType) -> ListDiffable
}
let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
// MARK: - CollectionManager

final class CollectionManager {
    /// 配置完成后需要做的事，目前没用到
    //    var completion: ((CollectionManager) -> Void) = { _ in }

    /// 包含的 元素
    var items: [ListDiffable] = []

    /// 我的ListManager 的唯一标识符
    var listManagerIdentifier: String = ""

    /// 我的唯一标识符
    var identifier: String = ""

    /// 是否启动请求数据
    var startRequest = true

    /// 请求类型
    public var request: (TargetType & TransformToListDiffable)?

    var sectionController: () -> ListSectionController

    /// 不含请求直接设置数据源
    ///
    /// - Parameters:
    ///   - identifier: <#identifier description#>
    ///   - items: <#items description#>
    ///   - sectionController: <#sectionController description#>
    init(_ identifier: String, items: [ListDiffable] = [], sectionController: @escaping () -> ListSectionController) {
        self.identifier = identifier
        self.sectionController = sectionController
        self.items = items;
        if let listManager = ManagerCenter.shared[self.listManagerIdentifier] {
            listManager.register(self)
        }
    }


    /// <#Description#>
    ///
    /// - Parameters:
    ///   - identifier: <#identifier description#>
    ///   - request: <#request description#>
    ///   - items: <#items description#>
    ///   - startRequest: <#startRequest description#>
    ///   - sectionController: <#sectionController description#>
    init(_ identifier: String, request: TargetType & TransformToListDiffable , items: [ListDiffable] = [], startRequest: Bool = true, sectionController: @escaping () -> ListSectionController) {

        self.identifier = identifier
        self.request = request
        self.sectionController = sectionController
        self.startRequest = startRequest
        self.items = items;
        if !self.startRequest {
            return
        }
        self.request(self.request!)
    }

    func request(_ targetType: TargetType & TransformToListDiffable) {
        provider.request(MultiTarget(targetType)) { (result) in
            do {
                /// 重新创建一个模型和我的所有属性相同（以后想想能否通过实现 NSCopy 来优化）
                /// startRequest 设置为 false,防止重复循环请求，陷入死循环
                let myNewItem = CollectionManager(self.identifier, request: self.request!, items: self.items, startRequest: false, sectionController: self.sectionController)
                let response = try result.dematerialize()

                myNewItem.items = targetType.models(response, targetType: self.request!)
                if let listManager = ManagerCenter.shared[self.listManagerIdentifier],
                    listManager.itemIdentifiers.contains(self.identifier) {
                    //重新注册，替换原来的对应元素
                    listManager.register(myNewItem)
                } else {
                    assert(false, "哪里弄错了？")
                }
            } catch {
                //                let printableError = error as CustomStringConvertible
                //                let errorMessage = printableError.description
            }
        }
    }


}
