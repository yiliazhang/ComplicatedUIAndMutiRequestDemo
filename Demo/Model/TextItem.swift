//
//  TextModel.swift
//  Demo
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
final class TextItem: NSObject {
    var title: String

    init(_ text: String = "") {
        self.title = text
    }
}

extension TextItem: MyModable {
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
        return LabelCell.self
    }

    var cellNibName: String {
        return ""
    }

    var sectionControllerClass: ListSectionController.Type {
        return ListSectionController.self
    }
}
