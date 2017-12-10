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

@objcMembers class DataSourceManager: NSObject {
    static let shared = DataSourceManager()

    weak var delegate: UpdateData?

    private var _items: [DemoItem] = []
    @objc dynamic var items: [DemoItem] {
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

    private override init() {
        super.init()
    }

    public func startRequests() {
        currentPageCount = 0

        ///下面的atIndex 写的这么具体是防止各个线程完成顺序不一样打乱了布局先后上下结构
        startItemsRequest(DemoItem(), atIndex: 0)
        startItemsTwoRequest(DemoItem(), atIndex: 1)
        startItemsThreeRequest(DemoItem(), atIndex: 2)
        startItemsFourRequest(DemoItem(), atIndex: 3)
    }

    private func loadMoreRequest() {
        currentPageCount = currentPageCount + 1
        //TODO: - 新增数据请求
        startItemsFourRequest(DemoItem(), atIndex: items.count)
    }

    private func clearData() {
        _items.removeAll()
    }

    private func insert(_ item: DemoItem, atIndex: Int) {
        if self._items.count > 0 {
            if self._items.contains(item) {
                return
            }

            if self._items.count > (atIndex - 1) {
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
        let queueThree = DispatchQueue(label: "three")

        queueOne.async(group: group) {
        semaphore.wait()
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

// MARK - : ListAdapterDataSource

extension DataSourceManager: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects: [ListDiffable] = self._items
        if loading {
            objects.append(loadingMoreSpinToken as ListDiffable)
        }
        if refreshing {
            objects.insert(refreshSpinToken as ListDiffable, at: 0)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, (obj == loadingMoreSpinToken || obj == refreshSpinToken) {
            return spinnerSectionController()
        } else {
            if let myObject = object as? DemoItem {
                let sectionControllers = myObject.sectionControllerNames.map { (key, _ ) -> ListSectionController in
                    if let sectionController = key.swiftClass() as? ListSectionController {
                        return sectionController
                    }
                    return ListSectionController()
                }
                let sectionController = ListStackedSectionController(sectionControllers: sectionControllers)
                sectionController.inset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
                return sectionController
            } else  {
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
                    DataSourceManager.shared.loadMoreRequest()
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
                    DataSourceManager.shared.startRequests()
                    self.delegate?.update()
                }
            }
        }
    }
}
