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

final class HorizontalSectionController: ListSectionController, ListAdapterDataSource {

    var items: [ListDiffable] = []
    var collectionItem: CollectionItem?
    var itemSize: CGSize = .zero
    var didSelectBlock: ((ListSectionController, ListDiffable) -> Void)?
    var didDeselectBlock: ((ListSectionController, ListDiffable) -> Void)?
    var cellBlock: ((ListSectionController, ListDiffable) -> UICollectionViewCell)?
    private var height: CGFloat = 0
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                    viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    init(_ size: CGSize = .zero) {
        super.init()
        self.itemSize = size
    }

    override func didUpdate(to object: Any) {
        items.removeAll()
        collectionItem = object as? CollectionItem
        items = collectionItem?.items ?? []
    }


    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: defaultItemWidth, height: itemSize.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self,
                                                                for: self,
                                                                at: index) as? EmbeddedCollectionViewCell else {
                                                                    fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = RowSectionController()
        controller.cellBlock = self.cellBlock
        controller.didDeselectBlock = self.didDeselectBlock
        controller.didSelectBlock = self.didSelectBlock
        controller.itemSizeBlock = { _, _ in
            return self.itemSize
        }

        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
