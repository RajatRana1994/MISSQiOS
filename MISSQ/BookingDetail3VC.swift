//
//  BookingDetail3VC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class BookingDetail3VC: UIViewController {
    @IBOutlet weak var lblCategory: UIButton!
    @IBOutlet weak var imgBefore: UIImageView!
    @IBOutlet weak var imgAfter: UIImageView!
    var bookingID: String = ""
    var userID: String = ""
    var dict = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiGetData()
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "booking/\(self.bookingID)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let dict = response["data"]
                self.dict = dict
                self.lblCategory.setTitle(dict["serviceDetails"]["name"].stringValue, for: .normal)
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["error_message"].stringValue, position: .top)
                
            }
        } failureHandler: { (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                self.apiGetData()
            })
        } progressHandler: { (progress) in
            
        }
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSelectImageBeforeAction(sender:UIButton){
        ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
            self.imgBefore.image = img
            sender.setImage(nil, for: .normal)
        }
    }
    @IBAction func btnSelectImageAfterAction(sender:UIButton){
        ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
            self.imgAfter.image = img
            sender.setImage(nil, for: .normal)
        }
    }
    @IBAction func btnAcceptAction(sender: UIButton){
        if self.imgBefore.image == nil{
            AlertToastManager.shared.addToast(self.view, message: "please_select_before_image".localized(), position: .top)
        }else if self.imgAfter.image == nil{
            AlertToastManager.shared.addToast(self.view, message: "please_select_after_image".localized(), position: .top)
        }else{
            self.apiSubmitData()
        }
    }
    func apiSubmitData()  {
        var parameter = Dictionary<String, String>()
        var temp = [MultipartData]()
        temp.append(MultipartData.init(medaiObject: self.imgBefore.image, mediaKey: "serviceProofPic1"))
        temp.append(MultipartData.init(medaiObject: self.imgAfter.image, mediaKey: "serviceProofPic2"))
        ServerManager.shared.showHud()
        
        
        print(parameter)
        ServerManager.shared.httpUploadWithHeader(api: API_BASE_URL + "booking/\(self.bookingID)/3",method: .put, params: parameter, multipartObject: temp, successHandler: { (JSON) in
            ServerManager.shared.hidHud()
            if JSON["status"].intValue == 200 {
                let vc = AppDelegate.getViewController(identifire: "BookingDetail4VC") as! BookingDetail4VC
                vc.hidesBottomBarWhenPushed = true
                vc.bookingID = self.bookingID
                vc.userID = self.userID
                vc.dict = self.dict
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                AlertToastManager.shared.addToast(self.view, message: JSON["error_message"].stringValue, position: .top)
            }
        }, failureHandler: { (error) in
            ServerManager.shared.hidHud()
            AppManager.showErrorDialog(viewControler: self, message: AppManager.getErrorMessage(error! as NSError))
        }) { (progress) in
            // self.UpdateProgressBar(progress: progress!)
        }
    }
}
