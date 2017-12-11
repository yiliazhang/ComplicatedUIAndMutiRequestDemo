//
//  GridItem.swift
//  Demo
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit
final class GridItem: NSObject {
    var backgroundImageURL: String
    var backgroundImageName: String
    var imageName: String
    var title: String
    var viewController: UIViewController

    init(_ backgroundImageURL: String = "", backgroundImageName: String = "", imageName: String = "", title: String = "", viewController: UIViewController = DetailViewController()) {
        self.backgroundImageURL = backgroundImageURL
        self.backgroundImageName = backgroundImageName
        self.imageName = imageName
        self.title = title
        self.viewController = viewController
        self.viewController.title = title
    }
}

extension GridItem: MyModable {
    var items: [ListDiffable] {
        return []
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }

    var cellClass: AnyClass {
        return GridCell.self
    }

    var cellNibName: String {
        return ""
    }

    var sectionControllerClass: ListSectionController.Type {
        return ListSectionController.self
    }
}
