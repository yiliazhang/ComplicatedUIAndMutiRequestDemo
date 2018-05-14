//
//  GridItem.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit

@objcMembers final class GridItem: NSObject {
    dynamic var backgroundImageURL: String
    dynamic var backgroundImageName: String
    dynamic var imageName: String
    dynamic var title: String
    dynamic var viewController: UIViewController
    init(backgroundImageURL: String = "", backgroundImageName: String = "", imageName: String = "", title: String = "", viewController: UIViewController = DetailViewController()) {
        self.backgroundImageURL = backgroundImageURL
        self.backgroundImageName = backgroundImageName
        self.imageName = imageName
        self.title = title
        self.viewController = viewController
        self.viewController.title = title
    }
}

extension GridItem: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }
}


