//
//  ChangePAsswordVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import Cosmos
class ChangePAsswordVC: UIViewController {
    @IBOutlet weak var tfOldPassword:UITextField!
    @IBOutlet weak var tfNewPassword:UITextField!
    @IBOutlet weak var tfConfirmPassword:UITextField!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var avgRating:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var rateView:CosmosView!
    var name: String = ""
    var email: String = ""
    var rating: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tfOldPassword.isSecureTextEntry = true
        tfNewPassword.isSecureTextEntry = true
        tfConfirmPassword.isSecureTextEntry = true
        lblName.text = name
        lblEmail.text = email
        rateView.rating = rating
        avgRating.text = "\(rating)"
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ChangePasswordButton(sender:UIButton){
           
        if (tfOldPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_your_current_password".localized(), position: .top)
        }else if (tfNewPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_your_new_password".localized(), position: .top)
        }else if tfNewPassword.text?.count ?? 0 < 8 {
            AlertToastManager.shared.addToast(self.view, message: "password_should_be_of_8_digits".localized(), position: .top)
        }else if (tfConfirmPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_confirm_password".localized(), position: .top)
        }else if tfNewPassword.text != tfConfirmPassword.text! {
            AlertToastManager.shared.addToast(self.view, message: "password_dosen't_match".localized(), position: .top)
        }else{
            self.changepasswordApi()
        }
       }
       func changepasswordApi()  {
           var parameter = Dictionary<String, String>()
           parameter["old_password"] = self.tfOldPassword.text!
           parameter["new_password"] = self.tfNewPassword.text!
           print(parameter)
           ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_CHANGE_PASSWORD,type: .post, params: parameter, successHandler: { (response) in
               print(response)
               ServerManager.shared.hidHud()
               AlertManager.shared.hideErrorView()
               
               if response["status"].intValue == 200 {
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: response["message"].stringValue, cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                       self.navigationController?.popViewController(animated: true)
                   })
               }else{
                   ServerManager.shared.errorMessage(errorCode
                       : response["success"].intValue, errorMessage: response["message"].stringValue, viewController: self)
               }
           }){ (error) in
               ServerManager.shared.hidHud()
               AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                   // self.GetStateFunction(countryIdd: countryIdd)
               })
           }
       }
}
