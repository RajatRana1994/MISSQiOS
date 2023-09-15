//
//  ChooseTypeVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 01/04/22.
//

import UIKit
import Localize_Swift

class ChooseTypeVC: UIViewController {
    @IBOutlet weak var lblOr:UILabel!
    @IBOutlet weak var lblAlreayAUser:UIButton!
    @IBOutlet weak var btnLogin:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.accessibilityHint == "social"{
            lblOr.isHidden = true
            lblAlreayAUser.isHidden = true
            btnLogin.isHidden = true
        }
    }
    @IBAction func btnLoginAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCustomerAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "CustomerSignUpVC") as! CustomerSignUpVC
        vc.accessibilityHint = self.accessibilityHint
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEmployeeAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "EmployeeSignUpVC") as! EmployeeSignUpVC
        vc.accessibilityHint = self.accessibilityHint
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
