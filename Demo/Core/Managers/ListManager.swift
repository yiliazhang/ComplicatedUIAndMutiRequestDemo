//
//  ListManager.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

@objc protocol UpdateData {

    ///  让 delegate 实现刷新方法
    func update()
}

class ListManager: NSObject {
    weak var delegate: UpdateData?

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

    convenience init(_ identifier: String, delegate: UpdateData) {
        self.init(identifier)
        self.delegate = delegate
    }


    /// 注册数据
    func register(_ item: CollectionManager) {
        let identifier = item.identifier
        item.listManagerIdentifier = self.identifier
        _itemKeyValues[identifier] = item
        delegate?.update()
    }

    /// 注册数据组
    func register(_ items: [CollectionManager]) {
        if items.count == 0 {
            return
        }
        items.forEach { (item) in
            item.listManagerIdentifier = self.identifier
            _itemKeyValues[item.identifier] = item
        }
        delegate?.update()
    }

    ///移除所有
    func removeAll() {
        _itemKeyValues.removeAll()
        delegate?.update()
    }

    ///移除 数据
    func remove(_ item: CollectionManager) {
        _itemKeyValues.removeValue(forKey: item.identifier)
        delegate?.update()
    }
    ///移除 数据组
    func remove(_ items: [CollectionManager]) {
        if items.count == 0 {
            return
        }
        items.forEach { (item) in
            _itemKeyValues.removeValue(forKey: item.identifier)
        }
        delegate?.update()
    }
}

// MARK - : ListAdapterDataSource
extension ListManager: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
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

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
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
        return myCollectionManager?.request.sectionController ?? ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let button = UIButton(type: .roundedRect)

        button.setTitleColor(UIColor.appTintColor, for: .normal)
        button.setTitle("不好意思，没数据", for: .normal)
        return button
    }
}



