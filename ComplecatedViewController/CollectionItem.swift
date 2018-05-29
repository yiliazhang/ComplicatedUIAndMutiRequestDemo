//
//  GridCollectionItem.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit

open class CollectionItem: NSObject {
    open var items: [ListDiffable] = []
    public init(_ items: [ListDiffable]) {
        super.init()
        self.items = items
    }
}

extension CollectionItem: ListDiffable {

    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }
}

