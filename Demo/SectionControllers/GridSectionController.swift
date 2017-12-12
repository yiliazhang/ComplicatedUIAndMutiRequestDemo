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
final class GridSectionController: ListSectionController, Identity {
    var items: [ListDiffable] = []
    var demoItem: DemoItem?
    override init() {
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
//        self.startRequest()
    }

    override func didUpdate(to object: Any) {
        demoItem = object as? DemoItem
        items = demoItem?.items ?? []
    }

    override func numberOfItems() -> Int {
        return items.count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let itemSize = floor(width / 4)
        return CGSize(width: itemSize, height: itemSize)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let object = self.demoItem,
            let value = object.items[index] as? GridItem else {
                assert(false, "传入的 model 类型不对？")
            return UICollectionViewCell()
        }
        let cell = collectionContext!.dequeueReusableCell(of: GridCell.self, for: self, at: index) as! GridCell
        //加载大图
        if !value.backgroundImageURL.isEmpty,
            let url = URL(string: value.backgroundImageURL) {
            cell.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(named: "spaceship.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            cell.backgroundImageView.image = nil
        }
        if value.imageName.isEmpty {
            cell.iconImageView.image = nil
        } else {
            cell.iconImageView.image = UIImage(named: value.imageName)
        }
        cell.label.text = value.title
        return cell
    }

    override func didSelectItem(at index: Int) {
        if let item = items[index] as? GridItem {
            let controller = item.viewController
            controller.title = item.title
            controller.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

