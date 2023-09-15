//
//  ImagePickerManager.swift
//  Instacam
//
//  Created by Apple on 01/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Localize_Swift
class ImagePickerManager: NSObject {
    static let shared = ImagePickerManager()
    
    private var imagePicker = UIImagePickerController()
    typealias CompletionHandler = (UIImage, Data)->Void
    var completion: CompletionHandler? = nil
    var isPresented : Bool = false
    var vc = UIViewController()
    func compressImage(_ image: UIImage, compressionRatio : Float = 0.1) -> Data? {
        var compressionQuality: Float = compressionRatio
        var imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        while Float((imageData! as NSData).length)/1024.0/1024.0 > 0.10 && compressionQuality > 0.02 {
            compressionQuality -= 0.05
            imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        }
        return imageData
    }
    func callPresentedOptions(_ sender: UIViewController, completion: CompletionHandler?) {
        self.isPresented = true
        vc = sender
        self.imagePicker.delegate = self
        self.completion = completion
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.checkCameraAuth()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.checkPhotoAuth()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
          break
        default:
            break
        }
        sender.present(alert, animated: true, completion: nil)
    }
    func callPickerOptions(_ sender: UIView, completion: CompletionHandler?) {
        sender.endEditing(true)
        self.isPresented = false
        self.imagePicker.delegate = self
        self.completion = completion
        
        let alert = UIAlertController(title: "choose_image".localized(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera".localized(), style: .default, handler: { _ in
            self.checkCameraAuth()
        }))
        alert.addAction(UIAlertAction(title: "gallery".localized(), style: .default, handler: { _ in
            self.checkPhotoAuth()
        }))
        alert.addAction(UIAlertAction.init(title: "cancel".localized(), style: .cancel, handler: nil))
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                if self.isPresented{
                    self.vc.present(self.imagePicker, animated: true, completion: nil)
                }else{
                UIApplication.shared.windows.first?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.shared.windows.first?.rootViewController!.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func openGallary()
    {
        DispatchQueue.main.async {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            if self.isPresented{
                self.vc.present(self.imagePicker, animated: true, completion: nil)
            }else{
            UIApplication.shared.windows.first?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Check the status of authorization for PHPhotoLibrary
    func checkPhotoAuth() {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status {
            case .authorized:
                print("Authorized")
                self.openGallary()
                
            case .restricted, .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    _ =  UIAlertController.showAlertInViewController(viewController: UIApplication.shared.windows.first?.rootViewController, withTitle: kAlertTitle, message: "We need to have access to your camera to take a New Photo.\nPlease go to the App Settings and allow Camera.", cancelButtonTitle: "Close", destructiveButtonTitle: nil, otherButtonTitles: ["Settings"], tapBlock: { (c, n, i) in
                        if i == 2{
                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    })
                })
            default:
                break
            }
        }
    }
    
    //MARK:- Check the status of authorization for Camera
    func checkCameraAuth() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
            if (videoGranted) {
                //Do Your stuff here
                self.openCamera()
            } else {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    _ =  UIAlertController.showAlertInViewController(viewController: UIApplication.shared.windows.first?.rootViewController, withTitle: kAlertTitle, message: "We need to have access to your camera to take a New Photo.\nPlease go to the App Settings and allow Camera.", cancelButtonTitle: "Close", destructiveButtonTitle: nil, otherButtonTitles: ["Settings"], tapBlock: { (c, n, i) in
                        if i == 2{
                           UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    })
                    
                    
                    
                })
                
            }
        })
    }
    
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK:- ImagePicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            let data = self.compressImage(pickedImage)
            if completion != nil {
                completion!(pickedImage, data!)
            }
        }
        
        if self.isPresented{
            vc.dismiss(animated: true, completion: nil)
        }else{
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if self.isPresented{
            vc.dismiss(animated: true, completion: nil)
        }else{
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
