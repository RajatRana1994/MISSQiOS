//
//  ReviewVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift
import Cosmos
class ReviewVC: UIViewController {
    @IBOutlet weak var lblAvgRating:UILabel!
    @IBOutlet weak var pv1:UIProgressView!
    @IBOutlet weak var pv2:UIProgressView!
    @IBOutlet weak var pv3:UIProgressView!
    @IBOutlet weak var pv4:UIProgressView!
    @IBOutlet weak var pv5:UIProgressView!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var tvView:UITextView!
    @IBOutlet weak var rateView:CosmosView!
    var bookingID: String = ""
    var userID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiGetData()
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "user/profile/\(userID)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let data = response["data"]
                self.imgProfile.sd_setImage(with: URL(string: data["profile"].stringValue), placeholderImage: UIImage(named: "app_logo"))
                self.lblAvgRating.text = String(format: "%.1f", data["rating"].doubleValue)
                self.lblName.text = data["name"].stringValue
                self.lblPhone.text = data["phone"].stringValue
                self.lblAddress.text = data["address"].stringValue
                self.pv1.progress = (data["ratingStars"]["rating5"].floatValue) / 10
                self.pv2.progress = (data["ratingStars"]["rating4"].floatValue) / 10
                self.pv3.progress = (data["ratingStars"]["rating3"].floatValue) / 10
                self.pv4.progress = (data["ratingStars"]["rating2"].floatValue) / 10
                self.pv5.progress = (data["ratingStars"]["rating1"].floatValue) / 10

            }else{
                AlertToastManager.shared.addToast(self.view, message: response["message"].stringValue, position: .top)
                
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
    @IBAction func btnAcceptAction(sender: UIButton){
        if (tvView.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_review".localized(), position: .top)
        }else{
            self.apiSubmitData()
        }
    }
    func apiSubmitData()  {
        var parameter = Dictionary<String, String>()
        parameter["rating"] = "\(self.rateView.rating)"
        parameter["comment"] = "\(self.tvView.text!)"
        parameter["bookingId"] = "\(self.bookingID)"
        print(parameter)
        var url : String = ""
        if self.accessibilityHint == "user"{
            // Rate to provider
            url = "rating/\(self.userID)/1"
        }else{
         url =   "rating/\(self.userID)/2"
        }
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + url,type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 201 {
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: response["message"].stringValue, cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    if self.accessibilityHint == "user"{
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                    windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetTabbarController()
                        
                    }else{
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetEmployeeTabbarController(type: 0, selectedIndex: 1)
                    }
                   })
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["error_message"].stringValue, position: .top)
            }
        }){ (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                // self.GetStateFunction(countryIdd: countryIdd)
            })
        }
    }

}
