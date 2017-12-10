/**
 Copyright (c) 2016-present, Facebook, Inc. All rights reserved.

 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import IGListKit

final class StackedViewController: UIViewController, ListAdapterDataSource, UIScrollViewDelegate {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var loading = false
    var refreshing = false
    let loadingMoreSpinToken = "loadingMoreSpinToken"
    let refreshSpinToken = "refreshSpinToken"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        DataSourceManager.shared.delegate = self
        DataSourceManager.shared.startRequests()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects: [ListDiffable] = DataSourceManager.shared.items
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
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }

    // MARK: UIScrollViewDelegate

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            DispatchQueue.global(qos: .default).async {
                // fake background loading task
                sleep(2)
                DispatchQueue.main.async {
                    self.loading = false
                    DataSourceManager.shared.loadMoreRequest()
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        }
        NSLog("y----=\(targetContentOffset.pointee.y)")
        if !refreshing && targetContentOffset.pointee.y <= -20 {
            refreshing = true
            adapter.performUpdates(animated: true, completion: nil)
            DispatchQueue.global(qos: .default).async {
                // fake background loading task
                sleep(2)
                DispatchQueue.main.async {
                    self.refreshing = false
                    DataSourceManager.shared.startRequests()
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        }
    }
}

extension StackedViewController: UpdateData {
    func update() {
        self.adapter.performUpdates(animated: true, completion: nil)
    }
}
