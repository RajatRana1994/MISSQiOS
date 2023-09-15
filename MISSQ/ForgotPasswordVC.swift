//
//  ForgotPasswordVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 02/04/22.
//

import UIKit
import Localize_Swift

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var tfEmail:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ForgotBtnAction(sender:UIButton){
        if (tfEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_email_address".localized(), position: .top)
               }else if AppManager.isValidEmail(self.tfEmail.text!) == false{
                AlertToastManager.shared.addToast(self.view, message: "please_enter_valid_email_address".localized(), position: .top)
               }else{
               self.ForgotApi()
        }
        
        
        
    }
    func ForgotApi()  {
        var parameter = Dictionary<String, String>()
        parameter["email"] = self.tfEmail.text!
        print(parameter)
        ServerManager.shared.showHud()
     ServerManager.shared.httpPost(request: API_FORGOT_PASSWORD, type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:response["message"].stringValue , cancelButtonTitle: "Ok".localized(), destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    self.navigationController?.popViewController(animated: true)
                })
               
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["message"].stringValue, position: .top)
                
            }
        }){ (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                self.ForgotApi()
            })
        }
    }
}
