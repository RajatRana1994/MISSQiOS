//
//  TopUpPayVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift

class TopUpPayVC: UIViewController {
    @IBOutlet weak var lblPayment: UILabel!
    var amount : Int = 100
    var clientScrect: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblPayment.text = "₱\(amount).00"
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAmountAction(sender: UIButton){
        if sender.tag == 0{
            amount = 100
        }else if sender.tag == 1{
            amount = 200
        }else if sender.tag == 2{
            amount = 300
        }else if sender.tag == 3{
            amount = 500
        }else if sender.tag == 4{
            amount = 1000
        }else if sender.tag == 5{
            amount = 2000
        }
        self.lblPayment.text = "₱\(amount).00"
    }
    @IBAction func btnSubmitAction(sender: UIButton){
        self.apiPaymentCharge()
    }
    func apiPaymentCharge()  {
        var parameter = Dictionary<String, String>()
        parameter["amount"] = "\(self.amount * 100)"
        print(parameter)
        ServerManager.shared.showHud()
     ServerManager.shared.httpPost(request: API_BASE_URL + "add-topup-paymongs",type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
         let checkOutUrl = response["data"]["paymongo"]["data"]["attributes"]["checkout_url"].stringValue
            if response["status"].intValue == 200 {
               
                let vc = AppDelegate.getViewController(identifire: "PaymentWebviewVC") as! PaymentWebviewVC
                vc.hidesBottomBarWhenPushed = true
                vc.accountUrl = checkOutUrl
                vc.isTopUp = true
                self.navigationController?.pushViewController(vc, animated: true)
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
    
    func apiAddAmount(json: String)  {
        var parameter = Dictionary<String, String>()
        parameter["amount"] = "\(self.amount)"
        parameter["transactionDetails"] = "\(json)"
        print(parameter)
        ServerManager.shared.showHud()
     ServerManager.shared.httpPost(request: API_BASE_URL + "add-topup",type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
             _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: response["message"].stringValue, cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                 let currentUser = loggedInUser
                 currentUser?.balance = response["data"]["userBalance"].stringValue
                 AppManager.saveLoggedInUser(currentUser: currentUser!)
                 AppManager.getLoggedInUser()
                 self.navigationController?.popToRootViewController(animated: false)
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
