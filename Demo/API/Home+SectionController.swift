//
//  Binder.swift
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
extension Home {
//    public var itemSize: CGSize {
//        switch self {
//        case .gridItem:
//            let itemSize = floor(screenWidth / 4)
//            return CGSize(width: itemSize, height: itemSize)
//        default:
//            return CGSize(width: screenWidth, height: 44)
//        }
//    }

    public var cellClass: AnyClass {
        switch self {
        case .gridItem:
            return GridCell.self
        case .image:
            return ImageCell.self
        case .text:
            return LabelCell.self
        case .centerText:
            return CenterLabelCell.self
        default:
            assert(false, "请设置 cellClass")
            return LabelCell.self
        }
    }

    public var sectionController: ListSectionController {
        switch self {
        case .gridItem:
            return gridSectionController()
        case .text:
            return textSectionController()
        case .image:
            return imageSectionController()
        case .centerText:
            return embeddedSectionController()
        default:
            assert(false, "你还没有设置 sectionController")
            return RowSectionController()
        }
    }


    private func textSectionController() -> RowSectionController {
        let sectionController = RowSectionController()
        sectionController.cellBlock = { (sectionController, item) in
            guard let cell = sectionController.collectionContext?.dequeueReusableCell(of: LabelCell.self, for: sectionController, at: 0) as? LabelCell,
            let item = item as? String else {
                assert(false, "是不是哪里配错了，看看 数据模型，或者 cell 类型是否有误呢")
//                fatalError()
            }
            cell.text = item
            return cell
        }
        return sectionController
    }


    private func imageSectionController() -> RowSectionController {
        let sectionController = RowSectionController()
        sectionController.itemSizeBlock =  { item in
            var height = 0
            if let urlString = sectionController.item as? String,
                let heightString = urlString.split(separator: "/").last {
                height = Int(heightString) ?? 0
            }
            return CGSize(width: defaultItemWidth, height: CGFloat(height))
        }
        sectionController.cellBlock = { (sectionController, item) in
            guard let cell = sectionController.collectionContext?.dequeueReusableCell(of: ImageCell.self, for: sectionController, at: 0) as? ImageCell,
                let item = item as? String else {
                    assert(false, "是不是哪里配错了，看看 数据模型，或者 cell 类型是否有误呢")
//                    fatalError()
            }
            //加载大图
            if !item.isEmpty,
                let url = URL(string: item) {
                cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "spaceship.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                cell.imageView.image = nil
            }
            return cell
        }
        return sectionController
    }

    private func gridSectionController() -> GridSectionController {
        let sectionController = GridSectionController()
        sectionController.itemSizeBlock =  { _ in
            let width = screenWidth/4
            return CGSize(width: width, height: width)
        }
        sectionController.cellBlock = { (sectionController, item) in
            guard let cell = sectionController.collectionContext?.dequeueReusableCell(of: GridCell.self, for: sectionController, at: 0) as? GridCell,
             let item = item as? GridItem else {
                assert(false, "是不是哪里配错了，看看 数据模型，或者 cell 类型是否有误呢")
//                fatalError()
            }

            if !item.backgroundImageURL.isEmpty,
                let url = URL(string: item.backgroundImageURL) {
                cell.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(named: "spaceship.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                if !item.backgroundImageName.isEmpty {
                     cell.backgroundImageView.image = UIImage(named: item.backgroundImageName)
                } else {
                    cell.backgroundImageView.image = nil
                }
            }
            if !item.imageName.isEmpty {
                 cell.iconImageView.image = UIImage(named: item.imageName)
            } else {
                 cell.iconImageView.image = nil
            }
            cell.label.text = item.title
            return cell
        }
        return sectionController
    }

    private func embeddedSectionController() -> HorizontalSectionController {
        let sectionController = HorizontalSectionController(CGSize(width: screenWidth / 4, height: 100))
        sectionController.cellBlock = { (sectionController, item) in
            guard let cell = sectionController.collectionContext?.dequeueReusableCell(of: CenterLabelCell.self, for: sectionController, at: 0) as? CenterLabelCell,
                let item = item as? String else {
                    assert(false, "是不是哪里配错了，看看 数据模型，或者 cell 类型是否有误呢")
//                    fatalError()
            }
            cell.text = item
            return cell
        }
        return sectionController
    }

}

