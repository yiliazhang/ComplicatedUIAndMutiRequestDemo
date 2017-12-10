//
//  DataSourceManager.swift
//  Demo
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
let semaphore = DispatchSemaphore(value: 6)
@objc protocol UpdateData {
    func update()
}

@objcMembers class DataSourceManager {
    static let shared = DataSourceManager()
    weak var delegate: UpdateData?

    private var _items: [DemoItem] = []

    @objc dynamic var items: [DemoItem] {
        return _items
    }

    private var itemOne = DemoItem()
    private var itemTwo = DemoItem()
    private var itemThree = DemoItem()
    private var itemFour = DemoItem()
    private var itemFive = DemoItem()

    private var currentPageCount = 0 {
        willSet {
            if newValue == 0 {
                clearData()
            }
        }
    }

    private init() {

    }

    public func startRequests() {
        currentPageCount = 0
        startItemsRequest(itemOne, atIndex: 0)
        startItemsTwoRequest(itemTwo, atIndex: 1)
        startItemsThreeRequest(itemThree, atIndex: 2)
        startItemsFourRequest(itemFour, atIndex: 3)
    }

    public func loadMoreRequest() {
        currentPageCount = currentPageCount + 1
        //TODO: - 新增数据请求
        startItemsFourRequest(DemoItem(), atIndex: items.count)
    }


    private func clearData() {
        _items = []
        itemOne = DemoItem()
        itemTwo = DemoItem()
        itemThree = DemoItem()
        itemFour = DemoItem()
        itemFive = DemoItem()
    }
    private func insert(_ item: DemoItem, atIndex: Int) {
        if self.items.count > 0 {
            if self.items.contains(item) {
                return
            }

            if self.items.count > (atIndex - 1) {
                self._items.insert(item, at: atIndex)
            } else {
                self._items.append(item)
            }
        } else {
            self._items.append(item)
        }
        self.delegate?.update()
    }

    private func startItemsRequest(_ item :DemoItem, atIndex: Int)  {
        ///网格
        let group = DispatchGroup()
        let queueOne = DispatchQueue(label: "one")
//        let queueTwo = DispatchQueue(label: "two")
        let queueThree = DispatchQueue(label: "three")
//        let queueFour = DispatchQueue(label: "four")

        queueOne.async(group: group) {
        semaphore.wait()
            // fake background loading task
//            sleep(1)
            semaphore.signal()
            DispatchQueue.main.async {
                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
                                GridItem(imageName: "icon_daka", title: "打卡签到"),
                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
                    NSLog("One GridSectionController")
                let classString = GridSectionController.description()
                item[classString] = tmpItems
            }
        }

        ///
        queueThree.async(group: group) {
            semaphore.wait()
            // fake background loading task
//            sleep(1)
            semaphore.signal()
            DispatchQueue.main.async {

                var tmpItems: [GridItem] = []
                var index = 12
                while index > 0 {
                    index = index - 1
                    tmpItems.append(GridItem(backgroundImageName: "spaceship.jpg"))
                }
                index = 5
                while index > 0 {
                    index = index - 1
                    tmpItems.append(GridItem(imageName: "icon_fjgl"))
                }
                index = 10
                while index > 0 {
                    index = index - 1
                    tmpItems.append(GridItem(title: Int(arc4random() % 20).description))
                }
                NSLog("One HorizontalSectionController")

                let classString = HorizontalSectionController.description()
                item[classString] = tmpItems// as [ListDiffable]

            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.insert(item, atIndex: atIndex)
        }
    }

    private func startItemsTwoRequest(_ item :DemoItem, atIndex: Int)  {
        let group = DispatchGroup()
        let queueFive = DispatchQueue(label: "five")
//        let queueTwo = DispatchQueue(label: "two")
//        let queueThree = DispatchQueue(label: "three")
//        let queueFour = DispatchQueue(label: "four")

        ///网格
        queueFive.async(group: group) {
            semaphore.wait()
            sleep(1)
            semaphore.signal()
            DispatchQueue.main.async {
                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
                                GridItem(imageName: "icon_daka", title: "打卡签到"),
                                GridItem(imageName: "icon_daka", title: "附件管理")]
                NSLog("Two GridSectionController")
                let classString = GridSectionController.description()
                item[classString] = tmpItems
            }
        }

        group.notify(queue: DispatchQueue.main) {
            self.insert(item, atIndex: atIndex)
        }
    }

    private func startItemsThreeRequest(_ item :DemoItem, atIndex: Int)  {
        let group = DispatchGroup()
        let queueSix = DispatchQueue(label: "six")
        let queueSeven = DispatchQueue(label: "seven")

        ///
        queueSix.async(group: group) {
            semaphore.wait()
            // fake background loading task
            sleep(2)
            semaphore.signal()
            DispatchQueue.main.async {
                var tmpItems: [GridItem] = []
                var index = 100
                while index > 0 {
                    index = index - 1
                    let width = Int(arc4random() % 300) + 20
                    tmpItems.append(GridItem(backgroundImageURL: "https://unsplash.it/" + width.description + "/" + width.description))
                }
//                NSLog("Three GridSectionController")
                let classString = GridSectionController.description()
                item[classString] = tmpItems
            }
        }
        ///
        queueSeven.async(group: group) {
            semaphore.wait()
            // fake background loading task
            sleep(2)
            semaphore.signal()
            DispatchQueue.main.async {
                let tmpItems = [GridItem(title: "123"), GridItem(title: "456"),
                                GridItem(title: "789"), GridItem(title: "1010")]
//                NSLog("Three HorizontalSectionController")
                let classString = HorizontalSectionController.description()
                item[classString] = tmpItems
            }
        }

        group.notify(queue: DispatchQueue.main) {
            self.insert(item, atIndex: atIndex)
        }
    }

    private func startItemsFourRequest(_ item :DemoItem, atIndex: Int)  {
        ///
        let group = DispatchGroup()
        let queueEight = DispatchQueue(label: "eight")

        ///
        queueEight.async(group: group) {
            semaphore.wait()
            // fake background loading task
            sleep(2)
            semaphore.signal()
            DispatchQueue.main.async {
                var tmpItems: [String] = []
                var index = 3
                while index > 0 {
                    index = index - 1
                    let height = Int(arc4random() % 100) + 200
                    tmpItems.append("https://unsplash.it/" + UIScreen.main.bounds.size.width.description + "/" + height.description)
                }
                NSLog("Four WorkingRangeSectionController")
                let classString = WorkingRangeSectionController.description()
                item[classString] = tmpItems as [ListDiffable]
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.insert(item, atIndex: atIndex)
        }
    }
}
