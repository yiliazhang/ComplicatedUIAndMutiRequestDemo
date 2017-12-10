# ComplicatedUIAndMutiRequestDemo

本项目为页面多层复杂结构和多请求接口实现案例。

不才，请指教。

谢谢 ：）





**说明：**
本项目界面布局主要是借助[ IGListKit](https://github.com/Instagram/IGListKit) 完成。项目为 `MVC` 模式。用到的第三方开源框架也比较常见。没有用到 `Moya` 或者 `RxSwift`(主要是对后者不熟，没时间思考是否合适)，也没有内嵌 `Html5`。



## Requirements

- Xcode 9.0+

- iOS 9.0+

- Interoperability with Swift 4.0+

- CocoaPods



## 项目框架内容：

* `StackedViewController` ：展示所有内容的 ViewController。
  * 实现了 `ListAdapterDataSource`(功能参考`IGListKit`)；
  * 实现`UIScrollViewDelegat`(用于下拉刷新，上拉加载更多)；
  * 实现`UpdateData`刷新数据,是 `DataSourceManager.shared.delegate`

* `DataSourceManager`：处理StackedViewController页中的所有数据，所有的模块数据配置都是通过此类，不需要修改 `StackedViewController`。
  * `private var _items: [DemoItem] = []`私有变量
  * ` open var items: [DemoItem]`只读属性返回`_items`
  * `weak var delegate: UpdateData?`代理

* `DemoItem`： `_items` 中包含的元素。
  * `private var _sectionControllerNames: [String : [ListDiffable]] = [:]`私有变量(`ListDiffable`参考 IGListKit)
  * `sectionControllerNames`只读属性返回`_sectionControllerNames`
  * 实现了 subscript，方便直接下标访问

* `YILUtilKit`：  部分项目用到的东西，从以前的项目中一把抓过去了，可能有些内容比较冗余。




## 项目中的多请求处理：
只是用到了GCD DispatchSemaphore。后续再考虑别的方式优化。项目中是用 sleep 方式模仿线程耗时。`spaceship.jpg`是超大像素的图片。



## 其他：
项目中也考虑到了加载超大图，和超大量网络图片。目前效果来看，差强人意。



## 鸣谢！

感谢出题者带给我两天不睡不着觉的思考。