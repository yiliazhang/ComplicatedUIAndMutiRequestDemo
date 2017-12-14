//
//  SectionTypable.swift
//  Demo
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
import IGListKit
import Moya

let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
protocol SectionTypable {
    /// 包含的 元素
    var items: [ListDiffable] { get set }

    /// 我的ListManager 的唯一标识符
    var listManagerIdentifier: String  { get set }

    /// 我的唯一标识符
    var identifier: String  { get set }

    /// 是否启动请求数据
    var startRequest: Bool { get set }

    /// 请求类型
    var request: TargetType  { get set }

    var sectionController: () -> ListSectionController  { get set }
}
