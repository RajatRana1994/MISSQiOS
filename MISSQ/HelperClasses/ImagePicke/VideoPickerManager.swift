//
//  VideoPickerManager.swift
//  ValetIT
//
//  Created by iOS on 17/08/21.
//

import UIKit
import MobileCoreServices
import Photos
class VideoPickerManager: UIViewController {
    static let shared = VideoPickerManager()
    
    private var imagePicker = UIImagePickerController()
    typealias CompletionHandler = (UIImage, URL)->Void
    var completion: CompletionHandler? = nil
    var viewController = UIViewController()
    
    func compressImage(_ image: UIImage, compressionRatio : Float = 0.1) -> Data? {
        var compressionQuality: Float = compressionRatio
        var imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        while Float((imageData! as NSData).length)/1024.0/1024.0 > 0.10 && compressionQuality > 0.02 {
            compressionQuality -= 0.05
            imageData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        }
        return imageData
    }
    
    func callPickerOptions(_ view: UIViewController , completion: CompletionHandler?) {
        view.view.endEditing(true)
        self.viewController = view
        self.imagePicker.delegate = self
        self.completion = completion
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
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
         //   alert.popoverPresentationController?.sourceView = view
         //   alert.popoverPresentationController?.sourceRect = view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        view.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        DispatchQueue.main.async {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.imagePicker.cameraCaptureMode = .video
                self.imagePicker.videoMaximumDuration = 120
                self.viewController.present(self.imagePicker, animated: true, completion: nil)
            }else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func openGallary()
    {
        DispatchQueue.main.async {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.mediaTypes = ["public.movie"] //, "public.movie"
            self.imagePicker.allowsEditing = true
            self.imagePicker.videoMaximumDuration = 120
            self.viewController.present(self.imagePicker, animated: true, completion: nil)
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
                    _ =  UIAlertController.showAlertInViewController(viewController: UIApplication.shared.windows.first?.rootViewController, withTitle: kAlertTitle, message: "We need to have access to your camera to take a New Video.\nPlease go to the App Settings and allow Camera.", cancelButtonTitle: "Close", destructiveButtonTitle: nil, otherButtonTitles: ["Settings"], tapBlock: { (c, n, i) in
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
                    _ =  UIAlertController.showAlertInViewController(viewController: UIApplication.shared.windows.first?.rootViewController, withTitle: kAlertTitle, message: "We need to have access to your camera to take a New video.\nPlease go to the App Settings and allow Camera.", cancelButtonTitle: "Close", destructiveButtonTitle: nil, otherButtonTitles: ["Settings"], tapBlock: { (c, n, i) in
                        if i == 2{
                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    })
                    
                })
                
            }
        })
    }
}

extension VideoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK:- ImagePicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedVideoUrl = info[.mediaURL] as? URL {
                           
                           if let imageView = self.getThumbnailImage(forUrl: pickedVideoUrl){
                               do {
                                   guard let data = try? Data(contentsOf: pickedVideoUrl) else {
                                       return
                                   }
                                  print("File size before compression: \(Double(data.count / 1048576)) mb")
                                         ///Compressed Video Data
                                          let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
                                   self.compressVideo(inputURL: pickedVideoUrl as URL,
                                                        outputURL: compressedURL) { exportSession in
                                              guard let session = exportSession else {
                                                  return
                                              }
                                              switch session.status {
                                              case .unknown:
                                                  break
                                              case .waiting:
                                                  break
                                              case .exporting:
                                                  break
                                              case .completed:
                                                   guard let compressedData = try? Data(contentsOf: compressedURL) else {
                                                       return
                                                   }

                                                   print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                                               if self.completion != nil {
                                                   self.completion!(imageView, pickedVideoUrl )
                                               }
                                               break
                                              case .failed:
                                                  break
                                              case .cancelled:
                                                  break
                                              @unknown default:
                                               return
                                              }
                                          }
                                   
                               }catch let error {
                                   print(error.localizedDescription)
                               }
                           }
                       }
        picker.dismiss(animated: true, completion: nil)
    }
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
           let asset: AVAsset = AVAsset(url: url)
           let imageGenerator = AVAssetImageGenerator(asset: asset)
           imageGenerator.appliesPreferredTrackTransform = true
           do {
               let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
               return UIImage(cgImage: thumbnailImage)
           } catch let error {
               print(error.localizedDescription)
           }
           
           return nil
       }
    func compressVideo(inputURL: URL,
                             outputURL: URL,
                             handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
              let urlAsset = AVURLAsset(url: inputURL, options: nil)
              guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                             presetName: AVAssetExportPresetMediumQuality) else {
                  handler(nil)

                  return
              }

              exportSession.outputURL = outputURL
              exportSession.outputFileType = .mp4
              exportSession.exportAsynchronously {
                  handler(exportSession)
              }
          }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        picker.dismiss(animated: true, completion: nil)
    }
}
