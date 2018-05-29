//
//  ManagerCenter.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
let semaphore = DispatchSemaphore(value: 6)
class ManagerCenter {
    static let shared = ManagerCenter()

    subscript(identifier: String) -> ListManager? {
        get {
            return _listManagers.filter({ (manager) -> Bool in
                return manager.identifier == identifier
            }).last
        }
    }

    @objc dynamic var identifiers: [String] {
        return _listManagers.map({ (item) -> String in
            return item.identifier
        })
    }

    private var _listManagers: [ListManager] = []
//    @objc dynamic var listManagers: [ListManager] {
//        return _listManagers
//    }

    func register(_ item: ListManager) {
        if _listManagers.contains(item) {
            return
        }
        _listManagers.append(item)
    }

    func remove(_ item: ListManager) {
        if !_listManagers.contains(item) {
            return
        }
        if let index = _listManagers.index(of: item) {
            _listManagers.remove(at: index)
        }
    }

    private init() {
    }
}
