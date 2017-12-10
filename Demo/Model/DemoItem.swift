//
//  DemoItem.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

final class DemoItem: NSObject {
    private var _sectionControllerNames: [String : [ListDiffable]] = [:]

    var sectionControllerNames: [String : [ListDiffable]] {
        return _sectionControllerNames
    }

    subscript(sectionControllerName: String) -> [ListDiffable] {
        get {
            let items = self._sectionControllerNames[sectionControllerName] ?? []
            return items
        }
        set {
            _sectionControllerNames[sectionControllerName] = newValue
        }
    }
}

extension DemoItem: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? DemoItem else { return false }
        if object.sectionControllerNames.count == sectionControllerNames.count {
            if sectionControllerNames.count == 0 {
                return true
            }
            let setOne = Set(sectionControllerNames.keys)
            let setTwo = Set(object.sectionControllerNames.keys)
            if setOne.intersection(setTwo).isEmpty {
                return false
            }
            if setOne.union(setOne) != setOne ||
               setOne.union(setOne) != setTwo {
                return false
            }
            //TODO: - 其他方面的判断
            return true
        } else {
            return false
        }
    }
}

@objcMembers final class GridItem: NSObject {
    dynamic var backgroundImageURL: String
    dynamic var backgroundImageName: String
    dynamic var imageName: String
    dynamic var title: String
    dynamic var viewController: UIViewController

    init(backgroundImageURL: String = "", backgroundImageName: String = "", imageName: String = "", title: String = "", viewController: UIViewController = DetailViewController()) {
        self.backgroundImageURL = backgroundImageURL
        self.backgroundImageName = backgroundImageName
        self.imageName = imageName
        self.title = title
        self.viewController = viewController
        self.viewController.title = title
    }
}

extension GridItem: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }
}
