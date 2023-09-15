//
//  SettingVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift

class SettingVC: UIViewController {
    @IBOutlet weak var lblEmail:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblEmail.text = loggedInUser.email
    }
    @IBAction func btnLogoutAction(){
        _ = UIAlertController.showAlertInViewController(viewController: self, withTitle: kAlertTitle, message: "Are you sure you want to logout?", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tapBlock: { (a, b, i) in
            if i == 2{
                ServerManager.shared.httpPost(request: API_BASE_URL + "logout", params: [:]) { json in
                    UserDefaults.standard.set(false, forKey: kIsLogin)
                    let vc = AppDelegate.getViewController(identifire: "LoginVC")as! LoginVC
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } failureHandler: { error in
                    
                }
            }
        })
    }
    
    @IBAction func onClickDeleteAccount(_ sender: UIButton) {
        _ = UIAlertController.showAlertInViewController(viewController: self, withTitle: kAlertTitle, message: "Are you sure you want to delete account?", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tapBlock: { (a, b, i) in
            if i == 2{ 
                ServerManager.shared.httpDelete(request: API_BASE_URL + "user-account-delete", params: [:]) { json in
                    UserDefaults.standard.set(false, forKey: kIsLogin)
                    let vc = AppDelegate.getViewController(identifire: "LoginVC")as! LoginVC
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } failureHandler: { error in
                    
                }
            }
        })
    }
    
    
    @IBAction func btnSupportAction(){
        let vc = AppDelegate.getViewController(identifire: "SupportVC")as! SupportVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnShareAction(){
            let objectsToShare:URL = URL(string: "http://www.google.com")!
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func btnNotificationAction(){
        let vc = AppDelegate.getViewController(identifire: "notificationVC")as! notificationVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTermsConditionVCAction(){
        let vc = AppDelegate.getViewController(identifire: "TermsConditionVC")as! TermsConditionVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLanguageAction(){
        let vc = AppDelegate.getViewController(identifire: "LanguageVC")as! LanguageVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
