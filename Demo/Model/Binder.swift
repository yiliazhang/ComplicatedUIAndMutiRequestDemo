//
//  Binder.swift
//  Demo
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
let defaultItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 44)

extension Home {
    public var sectionController: ListSectionController {
        switch self {
        case .text:
            return Home.sectionController(RowSectionController())
        default:
            return ListSectionController()
        }
    }

    private static func sectionController(_ sectionController: RowSectionController, itemSize: CGSize = defaultItemSize) -> RowSectionController {
        let sectionController = RowSectionController(itemSize)
        sectionController.cellBlock = { (sectionController, item) in
            guard let cell = sectionController.collectionContext?.dequeueReusableCell(of: LabelCell.self, for: sectionController, at: 0) as? LabelCell else {
                fatalError()
            }
            cell.text = (item as? String) ?? ""
            return cell
        }
        return sectionController
    }

}

