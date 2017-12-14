//
//  DemoViewController.swift
//  Demo
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit
class DemoViewController: RootListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Demo"
        configData()
    }

    /// 如果需要增加请求，在 HomeAPI 中增加，
    func configData() {
        listManager.removeAll()
//        let gridOne = CollectionManager("gridOne", request: Home.gridItem) { () -> ListSectionController in
//            return self.gridSectionController()
//        }
        let textOne = CollectionManager("textOne", request: Home.text) { () -> ListSectionController in
            return self.textSectionController()
        }
//        let imageOne = CollectionManager("imageOne", request: Home.image) { () -> ListSectionController in
//            return self.imageSectionController()
//        }
//        let centerTextOne = CollectionManager("centerTextOne", request: Home.centerText) { () -> ListSectionController in
//            return self.embeddedSectionController()
//        }

//        listManager.register([gridOne, textOne, centerTextOne, imageOne])
        listManager.register(textOne)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        sectionController.didSelectBlock = { (sectionController, item) in
            let controller = DetailViewController()
            controller.title = (item as? String) ?? ""
            sectionController.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
        return sectionController
    }


    private func imageSectionController() -> RowSectionController {
        let sectionController = RowSectionController()
        sectionController.itemSizeBlock =  { _, item in
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
        sectionController.didSelectBlock = { (sectionController, item) in
            let controller = DetailViewController()
            controller.title = "图片"
            sectionController.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
        return sectionController
    }

    private func gridSectionController() -> GridSectionController {
        let sectionController = GridSectionController()
        sectionController.itemSizeBlock =  { sectionController, _ in
            let width = screenWidth/4
            return CGSize(width: width, height: width)
        }
        sectionController.cellBlock = { sectionController, item in
            guard let cell = sectionController.collectionContext?.dequeueReusableCell(of: GridCell.self, for: sectionController, at: 0) as? GridCell else {
                                    assert(false, "是不是哪里配错了，看看 数据模型，或者 cell 类型是否有误呢")
                                    //                fatalError()
                            }
            do {
                let data = (item as AnyObject).data(using: String.Encoding.utf8.rawValue)
                let myItem = try JSONDecoder().decode(GridItem.self, from: data!)
                if  let avatar_url = myItem.avatar_url,
                let url = URL(string: avatar_url) {
                    cell.iconImageView.kf.setImage(with: url, placeholder: UIImage(named: "spaceship.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell.label.text = myItem.login ?? "未知"
                return cell
            } catch {
                return UICollectionViewCell()
            }
        }
        sectionController.didSelectBlock = { (sectionController, item) in
            var title = ""
            do {
                let data = (item as AnyObject).data(using: String.Encoding.utf8.rawValue)
                let myItem = try JSONDecoder().decode(GridItem.self, from: data!)
                title = myItem.login ?? ""
            } catch {

            }
            let controller = DetailViewController()
            controller.title = title
            sectionController.viewController?.navigationController?.pushViewController(controller, animated: true)
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
        sectionController.didSelectBlock = { (sectionController, item) in
            let controller = DetailViewController()
            controller.title = (item as? String) ?? ""
            sectionController.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
        return sectionController
    }

}
