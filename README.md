#  ComplicatedUIAndMutiRequestDemo

本项目为页面多层复杂结构和多请求接口实现案例。

不才，请指教。



谢谢   ：）



**说明：**
本项目界面布局主要是借助[ IGListKit](https://github.com/Instagram/IGListKit) ，网络请求选用的`Moya` 。



## Overview

![效果图](https://ws1.sinaimg.cn/large/006tNc79gy1fmg73d14gcg30af0ij1ey.gif)


## Requirements

- Xcode 9.0+
- iOS 9.0+
- Swift 4.0+
- CocoaPods




### Example



```Swift
class DemoViewController: RootListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configData()
    }

   func configData() {
        listManager.removeAll()
        let gridOne = CollectionManager("gridOne", request: Home.gridItem) { () -> ListSectionController in
            return self.gridSectionController()
        }
        let textOne = CollectionManager("textOne", request: Home.text) { () -> ListSectionController in
            return self.textSectionController()
        }
        let imageOne = CollectionManager("imageOne", request: Home.image) { () -> ListSectionController in
            return self.imageSectionController()
        }
        let centerTextOne = CollectionManager("centerTextOne", request: Home.centerText) { () -> ListSectionController in
            return self.embeddedSectionController()
        }
        listManager.register([gridOne, textOne, centerTextOne, imageOne])
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
```



## 项目框架内容：

* `RootListdViewController` ：最核心的ViewController，任何其他延伸实例都可以继承自它

  ​

  ``` Swift
  import IGListKit
  import Moya
  open class RootListViewController: UIViewController {
      /// IGListKit 需要用到
      lazy var adapter: ListAdapter = {
          return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
      }()

      /// 展示布局
      @IBOutlet public var collectionView: UICollectionView!

      /// 数据配置工具
      lazy var listManager: ListManager = {
          return ListManager(Date().description, delegate: self)
      }()

      override open func viewDidLoad() {
          super.viewDidLoad()
          if collectionView == nil {
              collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
          }
          if collectionView.superview == nil {
              view.addSubview(collectionView)
          }
          adapter.collectionView = collectionView
          adapter.dataSource = listManager
      }

      override open func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
      }
  }

  extension RootListViewController: UpdateData {
      func dataUpdated() {
          self.adapter.performUpdates(animated: true, completion: nil)
      }
  }
  ```

* `ListManager` 管理当前界面中的所有显示项
   ![结构图](https://ws4.sinaimg.cn/large/006tNc79gy1fmf57ufjrrj311o1aw4ok.jpg)

* ` CollectionManager`： 包含每个需要显示的元素组。 `listtManager`的`_itemKeyValues` 中的Value。

   ​

```Swift
final class CollectionManager {
  /// 配置完成后需要做的事，目前没用到
  var completion: ((CollectionManager) -> Void) = { _ in }
  /// 包含的 元素
  var items: [ListDiffable] = []
  /// 我的ListManager 的唯一标识符
  var listManagerIdentifier: String = ""
  /// 我的唯一标识符
  var identifier: String = ""
  /// 是否启动请求数据
  var startRequest = true
  /// 请求类型
  public var request: Home = .none
  weak var delegate: UpdateData?
  init(_ identifier: String, request: Home = .none, startRequest: Bool = true, completion: @escaping (CollectionManager) -> Void = {_ in }) {
      self.identifier = identifier
      self.completion = completion
      self.request = request
      self.startRequest = startRequest
      if self.request == .none {
          self.startRequest = false
          completion(self)
          return
      }
      if !self.startRequest {
          completion(self)
          return
      }
      /// 重新创建一个模型和我的所有属性相同（以后想想能否通过实现 NSCopy 来优化）
      /// startRequest 设置为 false,防止重复循环请求，陷入死循环
      let myNewItem = CollectionManager(self.identifier,request: self.request, startRequest: false, completion: self.completion)
      homeProvider.request(request) { (result) in
          var tmpItems: [ListDiffable] = []
          //TODO: - 数据转换
          switch request {
          case .gridItem:
              tmpItems = self.demoGridItems()// 假数据
          case .text:
              tmpItems = self.demoStrings() as [ListDiffable]// 假数据
          case .centerText:
              tmpItems = self.demoCenterStrings()// 假数据
          case .image:
              tmpItems = self.demoImageURLs() as [ListDiffable]// 假数据
          default:
              break
          }
          myNewItem.items = tmpItems
          if let listManager = ManagerCenter.shared[self.listManagerIdentifier],
              listManager.itemIdentifiers.contains(self.identifier) {
              //重新注册，替换原来的对应元素
              listManager.register(myNewItem)
              self.completion(myNewItem)
          }
      }
  }
}
```

* `ManagerCenter`：为单一实例，包含项目中的所有 listManager。

* 项目在 `IGListKit` 的基础上再次解耦封装了 
  * `RowListSectionController`
  * `HorizontalSectionController`
  * `GridSectionController`

* `YILUtilKit` ：其他。

* `CollectionItem`： CollectionManager 中的模型实现了 `ListDiffable`(参考 `IGListKit`)

  ​

## 鸣谢！

感谢出题者XXX的长篇指点。