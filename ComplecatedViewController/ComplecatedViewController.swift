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
open class ComplecatedViewController: UIViewController {
    /// IGListKit 需要用到
    open lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()

    /// 展示布局
    @IBOutlet public var collectionView: UICollectionView!

    /// 数据配置工具
    open lazy var listManager: ListManager = {
        return ListManager(Date().description, adapter: self.adapter)
    }()

    /// 展示布局
    @IBOutlet public var emptyView: UIView? {
        didSet {
            self.listManager.emptyView = emptyView
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if collectionView == nil {
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        }
        collectionView.backgroundColor = UIColor.white
        if collectionView.superview == nil {
            collectionView.frame = view.bounds
            view.addSubview(collectionView)
        }
        adapter.collectionView = collectionView
        adapter.dataSource = listManager
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
