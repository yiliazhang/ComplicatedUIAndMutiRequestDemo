//
//  ListManager.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

open class ListManager: NSObject {
    open weak var adapter: ListAdapter?

    var emptyView: UIView?

    private var _identifier: String!
    var identifier: String {
        return _identifier
    }

    private var _itemIdentifiers: [String] = []
    @objc dynamic var itemIdentifiers: [String] {
        return _itemIdentifiers
    }

    private var _itemKeyValues: [String: CollectionManager] = [:] {
        didSet {
            /// 过滤多余 key 和 添加漏掉的 key
            /// 删除_itemIdentifiers 中多余 key
            if _itemKeyValues.count == 0 {
                _itemIdentifiers.removeAll()
                return
            }

            let myIdentifiers = _itemIdentifiers.filter { (key) -> Bool in
                return _itemKeyValues.keys.contains(key)
            }
            _itemIdentifiers = myIdentifiers

            /// 添加 _itemIdentifiers 不存在的 key
            _itemKeyValues.keys.forEach { (key) in
                let contained = _itemIdentifiers.contains(key)
                if !contained {
                    _itemIdentifiers.append(key)
                }
            }
        }
    }

    /// 包含的 key 和对应的 CollectionManager
    var itemKeyValues: [String: CollectionManager] {
        return _itemKeyValues
    }


    /// - Parameter identifier: 唯一标识码
    init(_ identifier: String) {
        super.init()

        ManagerCenter.shared.register(self)
        self._identifier = identifier
    }

    /// 初始化函数
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识码
    ///   - delegate: 实现update 方法
    convenience init(_ identifier: String, adapter: ListAdapter) {
        self.init(identifier)
        self.adapter = adapter
    }

    /// 注册数据
    open func register(_ item: CollectionManager) {
        let identifier = item.identifier
        item.listManagerIdentifier = self.identifier
        _itemKeyValues[identifier] = item
        adapter?.performUpdates(animated: true, completion: nil)
    }

    /// 注册数据组
    open func register(_ items: [CollectionManager]) {
        if items.count == 0 {
            return
        }
        items.forEach { (item) in
            item.listManagerIdentifier = self.identifier
            _itemKeyValues[item.identifier] = item
        }
        adapter?.performUpdates(animated: true, completion: nil)
    }

    ///移除所有
    open func removeAll() {
        _itemKeyValues.removeAll()
        adapter?.performUpdates(animated: true, completion: nil)
    }

    ///移除 数据
    open func remove(_ item: CollectionManager) {
        _itemKeyValues.removeValue(forKey: item.identifier)
        adapter?.performUpdates(animated: true, completion: nil)
    }
    ///移除 数据组
    open func remove(_ items: [CollectionManager]) {
        if items.count == 0 {
            return
        }
        items.forEach { (item) in
            _itemKeyValues.removeValue(forKey: item.identifier)
        }
        adapter?.performUpdates(animated: true, completion: nil)
    }
}

extension ListManager: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var tmpItems: [ListDiffable] = []
        if _itemKeyValues.count == 0 {
            return tmpItems
        }

        let _ = _itemIdentifiers.map { (key) -> String in
            if let item = _itemKeyValues[key],
                item.items.count > 0 {
                tmpItems.append(contentsOf: item.items)
            }
            return key
        }
        return tmpItems
    }

    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        var find = false
        var myCollectionManager: CollectionManager?
        for (_ ,collectionManager) in _itemKeyValues {
            if collectionManager.items.count == 0 {
                continue
            }

            for item in collectionManager.items {
                if item.isEqual(toDiffableObject: object as? ListDiffable) {
                    myCollectionManager = collectionManager
                    find = true
                    break
                }
            }
            if find {
                break
            }
        }
        assert(myCollectionManager != nil, "没有包含这个 object  的 CollectionManager")
        if let sectionController = myCollectionManager?.sectionController {
            return sectionController()
        } else {
//            return RowSectionController()
            return ListSectionController()
        }
    }

    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return self.emptyView
    }
}
