//
//  UIView+CornerRadius.swift
//  clw
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 Datang. All rights reserved.
//

import Foundation
import UIKit
extension YIL where Base: UIView {
    func yil_roundRect(_ radius: CGFloat = 0,borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        var newRadius = radius
        if newRadius == 0 {
            newRadius = min(base.frame.size.width, base.frame.size.height) / 2
        }
        base.layer.cornerRadius = newRadius
        base.layer.borderWidth = borderWidth + 1
        base.layer.borderColor = borderColor.cgColor
        base.layer.masksToBounds = true
    }
    
    func yil_shadow(_ radius: CGFloat = 0, offsetX: CGFloat = 0, offsetY: CGFloat = 0, color: UIColor = .clear, alpha: Float = 1.0) {
        base.layer.shadowColor = color.cgColor;
        base.layer.shadowOffset = CGSize(width:offsetX, height: offsetY);
        base.layer.shadowOpacity = alpha;
        base.layer.shadowRadius = radius
    }
    
    func yil_corners(corners: UIRectCorner, radius : CGFloat) {
        let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = base.bounds
        cornerLayer.path = maskPath.cgPath
        base.layer.mask = cornerLayer
        
    }
}
