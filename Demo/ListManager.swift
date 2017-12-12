//
//  ListManager.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

let semaphore = DispatchSemaphore(value: 6)
@objc protocol Identity {
    var demoItem: DemoItem? { get set }
    var items: [ListDiffable] { get set }
}

typealias IdentityListSectionController = ListSectionController & Identity

@objc protocol UpdateData {
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

    private var _itemKeyValues: [String: DemoItem] = [:] {
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

    @objc dynamic var itemKeyValues: [String: DemoItem] {
        return _itemKeyValues
    }

    init(_ identifier: String) {
        super.init()
        ManagerCenter.shared.register(self)
        self._identifier = identifier
    }

    convenience init(_ identifier: String, delegate: UpdateData) {
        self.init(identifier)
        self.delegate = delegate
    }

    func register(_ item: DemoItem) {
        let identifier = item.identifier
        item.listManagerIdentifier = self.identifier
        _itemKeyValues[identifier] = item
        delegate?.update()
    }

    func register(_ items: [DemoItem]) {
        if items.count == 0 {
            return
        }
        items.forEach { (item) in
            item.listManagerIdentifier = self.identifier
            _itemKeyValues[item.identifier] = item
        }
        delegate?.update()
    }

    func removeAll() {
        _itemKeyValues.removeAll()
        delegate?.update()
    }

    func remove(_ item: DemoItem) {
        _itemKeyValues.removeValue(forKey: item.identifier)
        delegate?.update()
    }

    func remove(_ items: [DemoItem]) {
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
        return _itemIdentifiers.map { (key) -> DemoItem in
            return self._itemKeyValues[key]!
        }
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let myObject = object as? DemoItem,
            let mySectionController = myObject.sectionControllerName.swiftClass() as? ListSectionController {
            return mySectionController
        } else  {
            return ListSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let button = UIButton(type: .roundedRect)

        button.setTitleColor(UIColor.appTintColor, for: .normal)
        button.setTitle("不好意思，没数据", for: .normal)
        return button
    }
}
