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
    private var items: [GridItem] = []
    var object: DemoItem?
    override init() {
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
    }

    override func didUpdate(to object: Any) {
        self.object = object as? DemoItem
        let controllerString = GridSectionController.description()
        items.removeAll()
        if let myObject = self.object,
            let tmpItems = myObject[controllerString] as? [GridItem] {
                items.append(contentsOf: tmpItems)
        }
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
        let cell = collectionContext!.dequeueReusableCell(of: GridCell.self, for: self, at: index) as! GridCell
        let value = items[index]
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
        let controller = items[index].viewController
        controller.title = items[index].title
        controller.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
