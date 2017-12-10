//
//  YILImagePicker.swift
//  clw
//
//  Created by apple on 2016/10/25.
//  Copyright © 2016年 Datang. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

// MARK: camera utility

func isCameraAvailable() -> Bool {
    return UIImagePickerController.isSourceTypeAvailable(.camera)
}

func isRearCameraAvailable() -> Bool {
    return UIImagePickerController.isCameraDeviceAvailable(.rear)
}

func isFrontCameraAvailable() -> Bool {
    return UIImagePickerController.isCameraDeviceAvailable(.front)
}

func doesCameraSupportTakingPhotos() -> Bool {
    return cameraSupportsMedia((kUTTypeImage as String), sourceType: .camera)
}

func isPhotoLibraryAvailable() -> Bool {
    return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
}

func canUserPickVideosFromPhotoLibrary() -> Bool {
    return cameraSupportsMedia((kUTTypeMovie as String), sourceType: .photoLibrary)
}

func canUserPickPhotosFromPhotoLibrary() -> Bool {
    return cameraSupportsMedia((kUTTypeImage as String), sourceType: .photoLibrary)
}

func cameraSupportsMedia(_ paramMediaType: String, sourceType paramSourceType: UIImagePickerControllerSourceType) -> Bool {
    var result = false
    if paramMediaType.characters.count == 0 {
        return false
    }
    let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: paramSourceType)
    
    guard availableMediaTypes != nil else {
        return false
    }
    
    guard availableMediaTypes!.isEmpty else {
        return false
    }
    
    for (_ , mediaType) in availableMediaTypes!.enumerated() {
        if (mediaType == paramMediaType) {
            result = true
            break
        }
    }
    return result
}

func hasCameraAutoration() -> Bool {
    switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
    case .authorized:
        return true
        
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
        return false
        
    case .denied:
        let alertController = UIAlertController(title: "无权限访问相机", message: "是否希望重新授权？", preferredStyle: .alert)
        // Create the actions.
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        // Create the actions.
        let okAction = UIAlertAction(title: "取消", style: .default, handler: {(action: UIAlertAction) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        return false
    case .restricted:
        return false
    }
    
}
func hasPhotoAutoration() -> Bool {
    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized:
        return true
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization({ (status) in
            
        })
        return false
    case .denied:
        let alertController = UIAlertController(title: "无权限访问相册", message: "是否希望重新授权？", preferredStyle: .alert)
        // Create the actions.
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        // Create the actions.
        let okAction = UIAlertAction(title: "取消", style: .default, handler: {(action: UIAlertAction) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        return false
        
    case .restricted:
        return false
    }
}
var bdImagePickerInstance: YILImagePicker?
class YILImagePicker: NSObject {
    
//    typealias FinishPickerAction = (_ image: UIImage) -> Void
    
    var viewController: UIViewController?
    
    var finishPickerAction: ((_ image: UIImage) -> Void)?
    var allowEditing = false
    
    
    class func show(from viewController: UIViewController, allowsEditing: Bool, finishAction: @escaping (_ image: UIImage) -> Void) {
        if bdImagePickerInstance == nil {
            bdImagePickerInstance = YILImagePicker()
        }
        bdImagePickerInstance!.show(from: viewController, allowsEditing: allowsEditing, finishAction: finishAction)
    }
    
    
    func show(from viewController: UIViewController, allowsEditing: Bool, finishAction:  @escaping (_ image: UIImage) -> Void) {
        self.viewController = viewController
        self.finishPickerAction = finishAction
        self.allowEditing = allowsEditing
        
        let cancelButtonTitle = NSLocalizedString("cancel", comment: "")
        let picturesButtonTitle = NSLocalizedString("从相册选择", comment: "")
        let cameraButtonTitle = NSLocalizedString("拍照", comment: "")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        let selectPicAction = UIAlertAction(title: picturesButtonTitle, style: .default) { [weak self](action) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.viewController?.present(picker, animated: true, completion: nil)
        }
        
        let takeAPhotoAction = UIAlertAction(title: cameraButtonTitle, style: .default, handler: { [weak self](action) in
            if isCameraAvailable() { //doesCameraSupportTakingPhotos()
                let controller = UIImagePickerController()
                controller.sourceType = .camera
                if isFrontCameraAvailable() {
                    controller.cameraDevice = .front
                }
                var mediaTypes = [String]()
                mediaTypes.append(kUTTypeImage as String)
                controller.mediaTypes = mediaTypes
                controller.delegate = self
                controller.allowsEditing = allowsEditing
                self?.viewController?.present(controller, animated: true, completion: nil)
            } else {
                YILLog.info("相机不可用")
            }
        })
        // Add the actions.
        alertController.addAction(selectPicAction)
        alertController.addAction(takeAPhotoAction)
        alertController.addAction(cancelAction)
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
   
}

extension YILImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        YILLog.info(info.description)
        bdImagePickerInstance = nil;
        picker.dismiss(animated: true, completion: nil)
        
        var image = info[UIImagePickerControllerEditedImage];
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage];
        }

        
        if finishPickerAction != nil {
            finishPickerAction!(image! as! UIImage)
//            self.finishPickerAction(image!)
        }
        //        Profile.sharedInstance.image = image
        //        imageRow.cellUpdate {
        //            $0.iconView.image = image
        //        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        bdImagePickerInstance = nil;
        picker.dismiss(animated: true, completion: nil)
    }
}



