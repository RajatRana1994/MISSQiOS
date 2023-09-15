//
//  EWalletVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift

class EWalletVC: UIViewController {
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblDeposit: UILabel!
    @IBOutlet weak var lblUnderReview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.lblBalance.text = "₱\(loggedInUser.balance)"
        self.lblDeposit.text = "P0"
        self.lblUnderReview.text = "P0"
        self.apiGetData(type: "1")
    }
    
    func apiGetData(type: String) {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "wallet-transection?limit=20&offset=1&transectionType=\(type)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let data = response["data"]
                self.lblBalance.text = "₱\(data["balance"].stringValue)"
            } else {
                AlertToastManager.shared.addToast(self.view, message: response["error_message"].stringValue, position: .top)
                
            }
        } failureHandler: { (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                self.apiGetData(type: type)
            })
        } progressHandler: { (progress) in
            
        }
    }
    
    @IBAction func btnTopUpAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "TopUpPayVC") as! TopUpPayVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBalanceDetailsAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "BalanceDetailsVC") as! BalanceDetailsVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBankCardAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "PaymentCardsVC") as! PaymentCardsVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCashoutAction(sender: UIButton){
       
    }
}

var rootController1:UIViewController?{
    if let window =  UIApplication.shared.windows.first(where: { $0.isKeyWindow}){
        return window.rootViewController
    }
    return UIViewController()
}
