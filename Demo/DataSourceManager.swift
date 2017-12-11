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
    func reloadItem(_ atIndex: IndexSet)
}

@objc protocol ModelType {
    var cellClass: AnyClass { get }
    var cellNibName: String { get }
    var sectionControllerClass: ListSectionController.Type { get }
    var items: [ListDiffable] { get }
}

typealias MyModable = ModelType & ListDiffable

@objcMembers class DataSourceManager: NSObject {
    weak var delegate: UpdateData?

    private var _items: [MyModable] = []
    dynamic var items: [MyModable] {
        return _items
    }

    private var loading = false
    private var refreshing = false
    private let loadingMoreSpinToken = "loadingMoreSpinToken"
    private let refreshSpinToken = "refreshSpinToken"

    private var currentPageCount = 0 {
        willSet {
            if newValue == 0 {
                clearData()
            }
        }
    }

    func append(_ item: MyModable) {
        self._items.append(item)
        self.delegate?.update()
    }

    public func startRequests() {
        currentPageCount = 0
    }

    private func loadMoreRequest() {
        currentPageCount = currentPageCount + 1
        //TODO: - 新增数据请求
//        startItemsFourRequest(DemoItem(), atIndex: items.count)
    }

    private func clearData() {
        _items.removeAll()
    }

//    private func startItemsRequest(_ item :DemoItem, atIndex: Int)  {
//        ///网格
//        let group = DispatchGroup()
//        let queueOne = DispatchQueue(label: "one")
//        let queueThree = DispatchQueue(label: "three")
//
//        queueOne.async(group: group) {
//        semaphore.wait()
////            sleep(1)
//            semaphore.signal()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(imageName: "icon_zsk", title: "知识库"),
//                                GridItem(imageName: "icon_wghyw", title: "网格报表"),
//                                GridItem(imageName: "icon_daka", title: "打卡签到"),
//                                GridItem(imageName: "icon_fjgl", title: "附件管理")]
//                    NSLog("One GridSectionController")
//                let classString = GridSectionController.description()
//                item[classString] = tmpItems
//            }
//        }
//
//        ///
//        queueThree.async(group: group) {
//            semaphore.wait()
//
////            sleep(1)
//            semaphore.signal()
//            DispatchQueue.main.async {
//
//                var tmpItems: [GridItem] = []
//                var index = 12
//                while index > 0 {
//                    index = index - 1
//                    tmpItems.append(GridItem(backgroundImageName: "spaceship.jpg"))
//                }
//                index = 5
//                while index > 0 {
//                    index = index - 1
//                    tmpItems.append(GridItem(imageName: "icon_fjgl"))
//                }
//                index = 10
//                while index > 0 {
//                    index = index - 1
//                    tmpItems.append(GridItem(title: Int(arc4random() % 20).description))
//                }
//                NSLog("One HorizontalSectionController")
//
//                let classString = HorizontalSectionController.description()
//                item[classString] = tmpItems// as [ListDiffable]
//
//            }
//        }
//        group.notify(queue: DispatchQueue.main) {
//            self.insert(item, atIndex: atIndex)
//        }
//    }
//
//
//
//    private func startItemsThreeRequest(_ item :DemoItem, atIndex: Int)  {
//        let group = DispatchGroup()
//        let queueSix = DispatchQueue(label: "six")
//        let queueSeven = DispatchQueue(label: "seven")
//
//        ///
//        queueSix.async(group: group) {
//            semaphore.wait()
//
//            sleep(2)
//            semaphore.signal()
//            DispatchQueue.main.async {
//                var tmpItems: [GridItem] = []
//                var index = 100
//                while index > 0 {
//                    index = index - 1
//                    let width = Int(arc4random() % 300) + 20
//                    tmpItems.append(GridItem(backgroundImageURL: "https://unsplash.it/" + width.description + "/" + width.description))
//                }
//
//                let classString = GridSectionController.description()
//                item[classString] = tmpItems
//            }
//        }
//        ///
//        queueSeven.async(group: group) {
//            semaphore.wait()
//            // fake background loading task
//            sleep(2)
//            semaphore.signal()
//            DispatchQueue.main.async {
//                let tmpItems = [GridItem(title: "123"), GridItem(title: "456"),
//                                GridItem(title: "789"), GridItem(title: "1010")]
//
//                let classString = HorizontalSectionController.description()
//                item[classString] = tmpItems
//            }
//        }
//
//        group.notify(queue: DispatchQueue.main) {
//            self.insert(item, atIndex: atIndex)
//        }
//    }
//
//    private func startItemsFourRequest(_ item :DemoItem, atIndex: Int)  {
//        ///
//        let group = DispatchGroup()
//        let queueEight = DispatchQueue(label: "eight")
//
//        ///
//        queueEight.async(group: group) {
//            semaphore.wait()
//            // fake background loading task
//            sleep(2)
//            semaphore.signal()
//            DispatchQueue.main.async {
//                var tmpItems: [String] = []
//                var index = 3
//                while index > 0 {
//                    index = index - 1
//                    let height = Int(arc4random() % 100) + 200
//                    tmpItems.append("https://unsplash.it/" + UIScreen.main.bounds.size.width.description + "/" + height.description)
//                }
//                NSLog("Four WorkingRangeSectionController")
//                let classString = WorkingRangeSectionController.description()
//                item[classString] = tmpItems as [ListDiffable]
//            }
//        }
//        group.notify(queue: DispatchQueue.main) {
//            self.insert(item, atIndex: atIndex)
//        }
//    }
}

// MARK - : ListAdapterDataSource

extension DataSourceManager: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects: [ListDiffable] = self._items as [ListDiffable]
        if loading {
            objects.append(loadingMoreSpinToken as ListDiffable)
        }
        if refreshing {
            objects.insert(refreshSpinToken as ListDiffable, at: 0)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let object = object as? String,
        (object == loadingMoreSpinToken || object == refreshSpinToken) {
            return spinnerSectionController()
        } else {
            if let object = object as? MyModable {
                let sectionControllers = object.items.map({ (_) -> ListSectionController in
                    return object.sectionControllerClass.init()
                })
                let stackedSectionController = ListStackedSectionController(sectionControllers: sectionControllers)
                return stackedSectionController
            } else {
                assert(false, "不认识?")
                return ListSectionController()
            }
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(DataSourceManager.startRequests), for: .touchUpInside)
        button.setTitleColor(UIColor.appTintColor, for: .normal)
        button.setTitle("点击刷新", for: .normal)
        return button
    }
}

// MARK - : UIScrollViewDelegate

extension DataSourceManager: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 {
            loading = true
            delegate?.update()
            DispatchQueue.global(qos: .default).async {
                // fake background loading task
                sleep(2)
                DispatchQueue.main.async {
                    self.loading = false
                    self.loadMoreRequest()
                    self.delegate?.update()
                }
            }
        }

        if !refreshing && targetContentOffset.pointee.y <= -20 {
            refreshing = true
            delegate?.update()
            DispatchQueue.global(qos: .default).async {
                // fake background loading task
                sleep(2)
                DispatchQueue.main.async {
                    self.refreshing = false
                    self.startRequests()
                    self.delegate?.update()
                }
            }
        }
    }
}
