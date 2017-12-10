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

final class EmbeddedSectionController: ListSectionController {
    var text: GridItem?
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: height, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: GridCell.self, for: self, at: index) as? GridCell else {
            fatalError()
        }
        let value = text
        //加载大图
        if let image = value?.backgroundImageName,
            !image.isEmpty {
            cell.backgroundImageView.image = UIImage(named: image)
        } else {
            cell.backgroundImageView.image = nil
        }
        if let iconImage = value?.imageName,
            !iconImage.isEmpty {
            cell.iconImageView.image = UIImage(named: iconImage)
        } else {
            cell.iconImageView.image = nil
        }
        cell.label.text = value?.title ?? ""
        cell.backgroundColor = UIColor(red: 237/255.0, green: 73/255.0, blue: 86/255.0, alpha: 1)
        return cell
    }

    override func didUpdate(to object: Any) {
        text = (object as? GridItem) ?? GridItem()
    }

}
