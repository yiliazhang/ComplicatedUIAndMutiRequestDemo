//
//  CellProtocol.swift
//  Demo
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
protocol CellProtocol {
    associatedtype ItemType
    func config(_ model: ItemType?)
}
