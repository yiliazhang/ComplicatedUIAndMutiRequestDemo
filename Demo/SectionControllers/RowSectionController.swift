//
//  RowSectionController.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
let defaultItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 44)
final class RowSectionController: ListSectionController {
    var itemSizeBlock: ((ListDiffable) -> CGSize)?
    var cellBlock: ((ListSectionController, ListDiffable) -> UICollectionViewCell)?
    var item: ListDiffable?
    override init() {
        super.init()
    }

    init (_ itemSizeBlock: @escaping ((ListDiffable) -> CGSize) = { _ in return defaultItemSize }) {
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
        self.itemSizeBlock = itemSizeBlock
    }

    override func didUpdate(to object: Any) {
        item = (object as? ListDiffable) ?? nil
    }

    override func numberOfItems() -> Int {
        return item == nil ? 0 : 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        if let item = self.item,
            let block = self.itemSizeBlock {
            return block(item)
        }
        return defaultItemSize
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let item = self.item,
            let block = self.cellBlock {
            return block(self, item)
        }
        return UICollectionViewCell()
    }
}
