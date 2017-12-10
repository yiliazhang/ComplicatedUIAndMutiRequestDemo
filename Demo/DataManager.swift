//
//  DataManager.swift
//  Demo
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
//import IGListKit
//let semaphore = DispatchSemaphore(value: 5)
//@objc protocol UpdateData {
//    func update()
//}
//
//@objcMembers class DataSourceManager {
//    static let shared = DataSourceManager()
//    weak var delegate: UpdateData?
//
//    open var items: [DemoItem] = []
//    open var itemOne = DemoItem()
//    open var itemTwo = DemoItem()
//    open var itemThree = DemoItem()
//
//    private init() {
//    }
//
//    public func startRequests() {
//        startItemsRequest(itemOne)
//        startItemsTwoRequest(itemTwo)
//        startItemsThreeRequest(itemThree)
//    }
//
//
//    private func startItemsRequest(_ item :DemoItem)  {
//        ///网格
////        semaphore.signal()
//        DispatchQueue.global().async {
//            // fake background loading task
//            sleep(4)
//            NSLog("One GridSectionController -----item:\(item)")
////            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                NSLog("One register -----item:\(item)")
//                self.register(item, sectionControllerString: GridSectionController.description(), sectionItems: tmpItems)
//            }
//        }
//
//        ///
////        semaphore.signal()
//        DispatchQueue.global().async {
//            // fake background loading task
//            sleep(20)
//            NSLog("One WorkingRangeSectionController -----item:\(item)")
////            semaphore.wait()
//            DispatchQueue.main.async {
//                var tmpItems: [String] = []
//                var index = 10
//                while index > 0 {
//                    index = index - 1
//                    let height = Int(arc4random() % 200)
//                    tmpItems.append("https://unsplash.it/" + UIScreen.main.bounds.size.width.description + "/" + height.description)
//                }
//                NSLog("One register -----item:\(item)")
//                self.register(item,sectionControllerString: WorkingRangeSectionController.description(), sectionItems: tmpItems as [ListDiffable])
//            }
//        }
//
//        ///
////        semaphore.signal()
//        DispatchQueue.global().async {
//            // fake background loading task
//            sleep(3)
//            NSLog("One HorizontalSectionController -----item:\(item)")
////            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems: [String] = ["123", "456", "450006"]
//                NSLog("One register -----item:\(item)")
//                self.register(item, sectionControllerString: HorizontalSectionController.description(), sectionItems: tmpItems as [ListDiffable])
//            }
//        }
//    }
//
//    private func startItemsTwoRequest(_ item :DemoItem)  {
//        let item = DemoItem()
//        ///网格
////        semaphore.signal()
//        DispatchQueue.global().async {
//
//            // fake background loading task
//            sleep(3)
//            NSLog("Two GridSectionController -----item:\(item)")
////            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                NSLog("Two register -----item:\(item)")
//                self.register(item, sectionControllerString: GridSectionController.description(), sectionItems: tmpItems)
//            }
//        }
//    }
//
//    private func startItemsThreeRequest(_ item :DemoItem)  {
//        ///网格
////        semaphore.signal()
//        DispatchQueue.global().async {
//            // fake background loading task
//            sleep(3)
//            NSLog("Three GridSectionController -----item:\(item)")
////            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                NSLog("Three register -----item:\(item)")
//                self.register(item, sectionControllerString: GridSectionController.description(), sectionItems: tmpItems)
//            }
//        }
//
//        ///
////        semaphore.signal()
//        DispatchQueue.global().async {
//            // fake background loading task
//            sleep(3)
//            NSLog("Three HorizontalSectionController -----item:\(item)")
////            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems: [String] = ["123", "456", "456888", "12344", "45556", "45776888", ]
//                NSLog("Three register -----item:\(item)")
//                self.register(item, sectionControllerString: HorizontalSectionController.description(), sectionItems: tmpItems as [ListDiffable])
//            }
//        }
//    }
//
//    private func register(_ item: DemoItem, sectionControllerString: String, sectionItems: [ListDiffable]) {
//        item[sectionControllerString] = sectionItems
//        self.items.append(itemOne)
//        self.items.append(itemTwo)
//        self.items.append(itemThree)
//        self.delegate?.update()
//    }
//}














//import IGListKit
//let semaphore = DispatchSemaphore(value: 5)
//@objc protocol UpdateData {
//    func update()
//}
//
//@objcMembers class DataSourceManager {
//    static let shared = DataSourceManager()
//    weak var delegate: UpdateData?
//
//    open var items: [DemoItem] = []
//    open var itemOne = DemoItem()
//    open var itemTwo = DemoItem()
//    open var itemThree = DemoItem()
//
//    private init() {
//    }
//
//    public func startRequests() {
//        startItemsRequest(itemOne)
//        startItemsTwoRequest(itemTwo)
//        startItemsThreeRequest(itemThree)
//    }
//
//
//    private func startItemsRequest(_ item :DemoItem)  {
//        let group = DispatchGroup()
//
//        let queueOne = DispatchQueue(label: "one")
//        let queueTwo = DispatchQueue(label: "two")
//        let queueThree = DispatchQueue(label: "three")
//        //        let queueFour = DispatchQueue(label: "four")
//
//        group.notify(queue: DispatchQueue.main) {
//            // 下载完成
//            self.add(item)
//        }
//
//
//
//        ///网格
//        semaphore.signal()
//
//        queueOne.async(group: group) {
//            // fake background loading task
//            sleep(4)
//            NSLog("One GridSectionController -----item:\(item)")
//            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                NSLog("One register -----item:\(item)")
//                item[GridSectionController.description()] = tmpItems
//            }
//        }
//
//        ///
//        semaphore.signal()
//        queueTwo.async(group: group) {
//            // fake background loading task
//            sleep(20)
//            NSLog("One WorkingRangeSectionController -----item:\(item)")
//            semaphore.wait()
//            DispatchQueue.main.async {
//                var tmpItems: [String] = []
//                var index = 10
//                while index > 0 {
//                    index = index - 1
//                    let height = Int(arc4random() % 200)
//                    tmpItems.append("https://unsplash.it/" + UIScreen.main.bounds.size.width.description + "/" + height.description)
//                }
//                NSLog("One register -----item:\(item)")
//                item[WorkingRangeSectionController.description()] = tmpItems as [ListDiffable]
//            }
//        }
//
//        ///
//        semaphore.signal()
//        queueThree.async(group: group) {
//            // fake background loading task
//            sleep(3)
//            NSLog("One HorizontalSectionController -----item:\(item)")
//            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = ["123", "456", "450006"] as [ListDiffable]
//                NSLog("One register -----item:\(item)")
//                item[HorizontalSectionController.description()] = tmpItems
//            }
//        }
//    }
//
//    private func startItemsTwoRequest(_ item :DemoItem)  {
//        let group = DispatchGroup()
//
//        let queueOne = DispatchQueue(label: "one")
//        let queueTwo = DispatchQueue(label: "two")
//        let queueThree = DispatchQueue(label: "three")
//        let queueFour = DispatchQueue(label: "four")
//
//        group.notify(queue: DispatchQueue.main) {
//            // 下载完成
//            self.add(item)
//        }
//        ///网格
//        semaphore.signal()
//        DispatchQueue.global(qos: .default).async {
//
//            // fake background loading task
//            sleep(3)
//            NSLog("Two GridSectionController -----item:\(item)")
//            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                NSLog("Two register -----item:\(item)")
//                item[GridSectionController.description()] = tmpItems
//            }
//        }
//    }
//
//    private func startItemsThreeRequest(_ item :DemoItem)  {
//        ///网格
//        semaphore.signal()
//        DispatchQueue.global(qos: .default).async {
//            // fake background loading task
//            sleep(3)
//            NSLog("Three GridSectionController -----item:\(item)")
//            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                NSLog("Three register -----item:\(item)")
//                item[GridSectionController.description()] = tmpItems
//            }
//        }
//
//        ///
//        semaphore.signal()
//        DispatchQueue.global(qos: .default).async {
//            // fake background loading task
//            sleep(3)
//            NSLog("Three HorizontalSectionController -----item:\(item)")
//            semaphore.wait()
//            DispatchQueue.main.async {
//                let tmpItems = ["123", "456", "456888", "12344", "45556", "45776888"] as [ListDiffable]
//                NSLog("Three register -----item:\(item)")
//                item[HorizontalSectionController.description()] = tmpItems
//            }
//        }
//    }
//
//
//    private func register(_ item: DemoItem, sectionControllerString: String, sectionItems: [ListDiffable]) {
//        //        item[sectionControllerString] = sectionItems
//        if self.items.count > 0 {
//            if self.items.contains(item) {
//                return
//            }
//            if item == itemOne {
//                self.items.insert(item, at: 0)
//            } else if item == itemTwo {
//                self.items.insert(item, at: 1)
//            } else if item == itemThree {
//                self.items.insert(item, at: 2)
//            }
//        } else {
//            self.items.append(item)
//        }
//
//
//        self.delegate?.update()
//    }
//
//    private func add(_ item: DemoItem) {
//        //        item[sectionControllerString] = sectionItems
//        if self.items.count > 0 {
//            if self.items.contains(item) {
//                return
//            }
//            if item == itemOne {
//                self.items.insert(item, at: 0)
//            } else if item == itemTwo {
//                self.items.insert(item, at: 1)
//            } else if item == itemThree {
//                self.items.insert(item, at: 2)
//            }
//        } else {
//            self.items.append(item)
//        }
//
//
//        self.delegate?.update()
//    }
//}

