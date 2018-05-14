//
//  RowSectionController.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
let screenWidth = UIScreen.main.bounds.size.width
let defaultItemWidth = screenWidth
let defaultItemHeight: CGFloat = 44
let defaultItemSize = CGSize(width: defaultItemWidth, height: defaultItemHeight)
final class RowSectionController: ListSectionController {
    var itemSizeBlock: ((ListSectionController, ListDiffable) -> CGSize)?
    var didSelectBlock: ((ListSectionController, ListDiffable) -> Void)?
    var didDeselectBlock: ((ListSectionController, ListDiffable) -> Void)?

    var cellBlock: ((ListSectionController, ListDiffable) -> UICollectionViewCell)?
    var item: ListDiffable?
    
    override init() {
        super.init()
    }

    init (_ itemSizeBlock: @escaping ((ListSectionController, ListDiffable) -> CGSize) = { _,_  in return defaultItemSize }) {
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
            return block(self, item)
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

    override func didSelectItem(at index: Int) {
        if  let item = self.item,
            let block = self.didSelectBlock {
            return block(self, item)
        }
    }

    override func didDeselectItem(at index: Int) {
        if  let item = self.item,
            let block = self.didDeselectBlock {
            return block(self, item)
        }
    }
}
