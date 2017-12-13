/**
 Copyright (c) 2016-present, Facebook, Inc. All rights reserved.

 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import IGListKit
import Kingfisher
final class GridSectionController: ListSectionController {
    var items: [ListDiffable] = []
    var collectionItem: CollectionItem?

    var itemSizeBlock: ((ListSectionController, ListDiffable) -> CGSize)?
    var didSelectBlock: ((ListSectionController, ListDiffable) -> Void)?
    var didDeselectBlock: ((ListSectionController, ListDiffable) -> Void)?
    
    var cellBlock: ((ListSectionController, ListDiffable) -> UICollectionViewCell)?

    override init() {
        super.init()
    }

    override func didUpdate(to object: Any) {
        items.removeAll()
        collectionItem = object as? CollectionItem
        items = collectionItem?.items ?? []
    }

    override func numberOfItems() -> Int {
        return items.count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        if let block = self.itemSizeBlock {
            return block(self, items[index])
        }
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        return defaultItemSize
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let block = self.cellBlock {
            return block(self, self.items[index])
        }
        return UICollectionViewCell()
    }

    override func didSelectItem(at index: Int) {
        if let block = self.didSelectBlock {
            return block(self, self.items[index])
        }
    }
    override func didDeselectItem(at index: Int) {
        if let block = self.didDeselectBlock {
            return block(self, self.items[index])
        }
    }
}

