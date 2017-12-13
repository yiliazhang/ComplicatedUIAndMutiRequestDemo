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
import Moya

final class StackedViewController: UIViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var listManager: ListManager = {
        return ListManager("home", delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = listManager

        configData()
    }

    func configData() {
        listManager.removeAll()
//        let textOne = CollectionManager("textOne", request: Home.text)
        let imageOne = CollectionManager("imageOne", request: .image)



//        let emBeddedOne = CollectionManager("EmBeddedOne", request: .text)
//        let labelOne = CollectionManager("LabeldOne", request: .centerText)
//
//        let itemTwo = CollectionManager("GridTwo", request: .gridItem)
//        let emBeddedTwo = CollectionManager("EmBeddedTwo", request: .text)
//        let labelTwo = CollectionManager("LabeldTwo", request: .centerText)
//        let imageTwo = CollectionManager("imageTwo", sectionControllerName: ImageSectionController.description(), request: .image)
//
//        let itemThree = CollectionManager("GridOne", sectionControllerName: GridSectionController.description(), request: .gridItem)
//        let emBeddedThree = CollectionManager("EmBeddedThree", sectionControllerName: HorizontalSectionController.description(), request: .text)
//        let labelThree = CollectionManager("LabeldThree", sectionControllerName: LabelSectionController.description(), request: .centerText)
//        let imageThree = CollectionManager("imageThree", sectionControllerName: ImageSectionController.description(), request: .image)

//        listManager.register([itemOne, emBeddedOne, imageOne, labelOne, itemTwo, emBeddedTwo, labelTwo, imageTwo, itemThree, emBeddedThree, itemOne, labelThree, imageThree])
        listManager.register(imageOne)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension StackedViewController: UpdateData {
    func reloadItem(_ atSections: IndexSet) {
        self.collectionView.reloadSections(atSections)
    }

    func update() {
        self.adapter.performUpdates(animated: true, completion: nil)
    }
}
