//
//  UIImage+Color.swift
//  clw
//
//  Created by apple on 2016/10/14.
//  Copyright © 2016年 Datang. All rights reserved.
//

import UIKit

extension YIL where Base: UIImage {

    /// 创建圆角图片
    ///
    /// - Parameter radius: 半径
    /// - Returns: image
    func image(withCornerRadius radius: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.width)
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
        UIGraphicsGetCurrentContext()!.clip()
        base.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let insetValue = CGFloat(radius - 1)
        let newImage = image!.resizableImage(withCapInsets:
            UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue), resizingMode: .stretch)
        return newImage
    }

}

extension UIImage {
    ///根据颜色创建图片，可以设置圆角半径
    class func image(_ withColor: UIColor, radius: Int = 0) -> UIImage {
        var width = 1
        if radius > 0 {
            width = radius * 2
        }
        // 描述矩形
        let rect = CGRect(x: 0, y: 0, width: width, height: width)
        // 开启位图上下文
        if radius > 0 {
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        } else {
            UIGraphicsBeginImageContext(rect.size)
        }

        // 获取位图上下文
        let context = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        context.setFillColor(withColor.cgColor)
        if radius > 0 {
            context.addPath(UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(radius)).cgPath)
            context.clip()
            // 渲染上下文
            context.fill(rect)
            // 使用color演示填充上下文
            // 从上下文中获取图片
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let insetValue = CGFloat(radius - 1)
            let newImage = theImage!.resizableImage(withCapInsets:
                UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue), resizingMode: .stretch)
            return newImage
        } else {
            // 渲染上下文
            context.fill(rect)
            // 从上下文中获取图片
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return theImage!

        }
    }

    /// 图片缩放
    ///
    /// - Parameters:
    ///   - sourceImage: <#sourceImage description#>
    ///   - maxPoint: <#maxPoint description#>
    /// - Returns: <#return value description#>
    class func image(_ sourceImage: UIImage, byScalingToMaxPoint maxPoint: CGFloat) -> UIImage {
        if sourceImage.size.width < maxPoint {
            return sourceImage
        }
        var btWidth: CGFloat = 0.0
        var btHeight: CGFloat = 0.0
        if sourceImage.size.width > sourceImage.size.height {
            btHeight = maxPoint
            btWidth = sourceImage.size.width * (maxPoint / sourceImage.size.height)
        } else {
            btWidth = maxPoint
            btHeight = sourceImage.size.height * (maxPoint / sourceImage.size.width)
        }
        let targetSize = CGSize(width: btWidth, height: btHeight)
        return UIImage.imageByScalingAndCropping(forSourceImage: sourceImage, targetSize: targetSize)
    }


    /// 缩小 image
    ///
    /// - Parameters:
    ///   - sourceImage: <#sourceImage description#>
    ///   - targetSize: <#targetSize description#>
    /// - Returns: <#return value description#>
    class func imageByScalingAndCropping(forSourceImage sourceImage: UIImage, targetSize: CGSize) -> UIImage {
        var newImage: UIImage? = nil
        let imageSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if imageSize.equalTo(targetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }
            else {
                scaleFactor = heightFactor
            }
            // scale to fit width
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            // center the image
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }
            else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(targetSize)
        // this will crop
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            return sourceImage
        }
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        return newImage!
    }


    /// 获取截屏
    ///
    /// - Returns: UIImage
    class func screenShot() -> UIImage?  {
        // 1. 获取到窗口
        guard let window = UIApplication.shared.keyWindow  else {
            return nil
        }
        // 2. 开始上下文
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, true, 0);
        // 3. 将 window 中的内容绘制输出到当前上下文
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        // 4. 获取图片
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        // 5. 关闭上下文
        UIGraphicsEndImageContext();
        return screenShot
    }
}
