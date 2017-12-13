//
//  RowSectionController.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit

final class RowSectionController: ListSectionController {
    var itemSize = defaultItemSize
    var cellBlock: ((ListSectionController, ListDiffable) -> UICollectionViewCell)?
    var item: ListDiffable?
    override init() {
        super.init()
    }
    init (_ itemSize: CGSize = defaultItemSize) {
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
        self.itemSize = itemSize
    }
    static func section(itemSize: CGSize = defaultItemSize) -> RowSectionController {
        return RowSectionController(itemSize)
    }

    override func didUpdate(to object: Any) {
        item = (object as? ListDiffable) ?? nil
    }

    override func numberOfItems() -> Int {
        return item == nil ? 0 : 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return self.itemSize
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let item = self.item,
            let block = self.cellBlock {
            return block(self, item)
        }
        return UICollectionViewCell()
    }
}
