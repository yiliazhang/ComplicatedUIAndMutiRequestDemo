//
//  DemoItem.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import IGListKit
import Moya


let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])

typealias SectionControllerable = ListSectionController
final class DemoItem: NSObject {
    private var _items: [ListDiffable] = []

    var completion: ((DemoItem) -> Void)?
    private var _cellClass: AnyClass = UICollectionViewCell.self
    private var _modelType: ListDiffable.Type?
    private var _cellNibName: String = ""
    private var _sectionControllerClass: SectionControllerable.Type = ListSectionController.self

    init(_ sectionControllerClass: SectionControllerable.Type, modelType: ListDiffable.Type, cellClass: UICollectionViewCell.Type, completion: @escaping ((DemoItem) -> Void) = { _ in }) {
        super.init()
        self._cellClass = cellClass
        self._modelType = modelType
        self._sectionControllerClass = sectionControllerClass
        self.completion = completion

        DispatchQueue.global().async {
            semaphore.wait()
            sleep(2)
            semaphore.signal()
            DispatchQueue.main.async {
                var tmpItems: [ListDiffable] = []
                var index = 1
                while index > 0 {
                    index = index - 1
                    tmpItems.append(GridItem(backgroundImageName: "spaceship.jpg") as ListDiffable)
                }

                index = 4
                while index > 0 {
                    index = index - 1
                    let string = "Hello \(index)" as ListDiffable
                    tmpItems.append(string)
                }
                self._items.append(contentsOf: tmpItems)
                self.completion?(self)
            }
        }
    }
}

extension DemoItem: MyModable {
    var items: [ListDiffable] {
        return _items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        //TODO: - 其他方面的判断
        return true
    }

    var cellClass: AnyClass {
        return _cellClass
    }
    var cellNibName: String {
        return _cellNibName
    }

    var sectionControllerClass: ListSectionController.Type {
        return _sectionControllerClass

    }
}

