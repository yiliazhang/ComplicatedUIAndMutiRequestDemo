//
//  ImageSectionController.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
import Kingfisher
final class ImageSectionController: ListSectionController {
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
        let itemSize = floor(width / 1)
        var height = 0
        if items.count > 0,
            let urlString = items[index] as? String,
            let heightString = urlString.split(separator: "/").last {
            height = Int(heightString) ?? 0
        }

        return CGSize(width: itemSize, height: CGFloat(height))
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let object = self.demoItem,
            let value = object.items[index] as? String else {
                assert(false, "传入的 model 类型不对？")
                return UICollectionViewCell()
        }
        let cell = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
        //加载大图
        if !value.isEmpty,
            let url = URL(string: value) {
            cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "spaceship.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            cell.imageView.image = nil
        }
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
