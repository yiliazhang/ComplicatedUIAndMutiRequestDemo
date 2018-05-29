//
//  RowSectionController.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
public let screenWidth = UIScreen.main.bounds.size.width
public let defaultItemWidth = screenWidth
public let defaultItemHeight: CGFloat = 44
public let defaultItemSize = CGSize(width: defaultItemWidth, height: defaultItemHeight)
open class RowSectionController: ListSectionController {
    open var itemSizeBlock: ((ListSectionController, ListDiffable) -> CGSize)?
    open var didSelectBlock: ((ListSectionController, ListDiffable) -> Void)?
    open var didDeselectBlock: ((ListSectionController, ListDiffable) -> Void)?

    open var cellBlock: ((ListSectionController, ListDiffable) -> UICollectionViewCell)?
    open var item: ListDiffable?

    public init (_ itemSizeBlock: @escaping ((ListSectionController, ListDiffable) -> CGSize) = { _,_  in return defaultItemSize }) {
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
        self.itemSizeBlock = itemSizeBlock
    }

    override open func didUpdate(to object: Any) {
        item = (object as? ListDiffable) ?? nil
    }

    override open func numberOfItems() -> Int {
        return item == nil ? 0 : 1
    }

    override open func sizeForItem(at index: Int) -> CGSize {
        if let item = self.item,
            let block = self.itemSizeBlock {
            return block(self, item)
        }
        return defaultItemSize
    }

    override open func cellForItem(at index: Int) -> UICollectionViewCell {
        if let item = self.item,
            let block = self.cellBlock {
            return block(self, item)
        }
        return UICollectionViewCell()
    }

    override open func didSelectItem(at index: Int) {
        if  let item = self.item,
            let block = self.didSelectBlock {
            return block(self, item)
        }
    }

    override open func didDeselectItem(at index: Int) {
        if  let item = self.item,
            let block = self.didDeselectBlock {
            return block(self, item)
        }
    }
}
