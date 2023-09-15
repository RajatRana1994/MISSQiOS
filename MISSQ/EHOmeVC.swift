//
//  EHOmeVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift

class EHOmeVC: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if loggedInUser.stripeId == ""{
//            self.apiGetStripeUrl()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedNotification), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
        if loggedInUser.serviceNAme.trimmingCharacters(in: .whitespacesAndNewlines) == "Child Tutor"{
            imgProfile.image = UIImage(named: "ten")
        }else if loggedInUser.serviceNAme.trimmingCharacters(in: .whitespacesAndNewlines) == "House Keeping"{
            imgProfile.image = UIImage(named: "two")
        }else if loggedInUser.serviceNAme.trimmingCharacters(in: .whitespacesAndNewlines) == "Nanny"{
            imgProfile.image = UIImage(named: "three")
        }else if loggedInUser.serviceNAme.trimmingCharacters(in: .whitespacesAndNewlines) == "Massage Therapist"{
            imgProfile.image = UIImage(named: "five")
        }else if loggedInUser.serviceNAme.trimmingCharacters(in: .whitespacesAndNewlines) == "Haircut"{
            imgProfile.image = UIImage(named: "eight")
        }else{
            imgProfile.image = UIImage(named: "nine")
        }
       
//
    }
    //MARK:- GET NOTIFICATION CHAT DATA
    @objc func tappedNotification(notification: Notification){
        
        if AppDelegate.sharedDelegate.notificationCode == "3" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = AppDelegate.getViewController(identifire: "NewRequestPopUpVC") as! NewRequestPopUpVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.chooseActionCompilation = { (isDetail) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let vc = AppDelegate.getViewController(identifire: "BookingDetail1VC") as! BookingDetail1VC
                        vc.hidesBottomBarWhenPushed = true
                        vc.bookingId = AppDelegate.sharedDelegate.bookingID
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                self.tabBarController?.present(vc, animated: true)
            }
        } else if AppDelegate.sharedDelegate.notificationCode ==  "24" {
            AppManager.getLoggedInUser()
            
            let user = loggedInUser
            let previou = (Int(loggedInUser.balance ?? "0") ?? 0) + AppDelegate.sharedDelegate.amount
            user?.balance = "\(previou )"
            AppManager.saveLoggedInUser(currentUser: user!)
            AppManager.getLoggedInUser()
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if let tabBarController  = rootController1 as? UITabBarController , let navController = tabBarController.selectedViewController as? UINavigationController ,  let visibleViewController = navController.visibleViewController {
                    let story = UIStoryboard.init(name: "Main", bundle: nil)
                    if visibleViewController.isKind(of: EWalletVC.self) {
                        let vw = visibleViewController as! EWalletVC
                        vw.lblBalance.text = "₱\(loggedInUser.balance)"
                    }
                }
            }
            
        } else if AppDelegate.sharedDelegate.notificationCode == "8"  {
            
            
            if let tabBarController  = rootController1 as? UITabBarController , let navController = tabBarController.selectedViewController as? UINavigationController ,  let visibleViewController = navController.visibleViewController {
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                if visibleViewController.isKind(of: MessageDetailVC.self) {
                    let vw = visibleViewController as! MessageDetailVC
                    if AppDelegate.sharedDelegate.bookingID == vw.bookingID {
                        vw.GetAllMessage()
                    } else {
                        vw.bookingID = AppDelegate.sharedDelegate.bookingID
                        vw.opponentID = AppDelegate.sharedDelegate.sender_id
                        vw.hidesBottomBarWhenPushed = true
                        navigationController?.pushViewController(vw, animated: true)
                    }
                    
                    
                } else {
                    
                    let vw = visibleViewController.storyboard?.instantiateViewController(withIdentifier: "MessageDetailVC") as! MessageDetailVC
                    if AppDelegate.sharedDelegate.bookingID == vw.bookingID {
                        vw.GetAllMessage()
                    } else {
                        vw.bookingID = AppDelegate.sharedDelegate.bookingID
                        vw.opponentID = AppDelegate.sharedDelegate.sender_id
                        vw.hidesBottomBarWhenPushed = true
                        navigationController?.pushViewController(vw, animated: true)
                    }
                }
            }
           
        }
    }
    @IBAction func btnAtRestAction(){
        self.apiChangeMode(type: "0")
    }
    @IBAction func btnOnDutyAction(){
        self.apiChangeMode(type: "1")
    }
    func apiChangeMode(type: String)  {
        var parameter = Dictionary<String, String>()
        parameter["isOnDuty"] =  type
        var temp = [MultipartData]()
        //temp.append(MultipartData.init(medaiObject: self.imgProfile.image, mediaKey: "profile"))
        ServerManager.shared.showHud()
        print(parameter)
        ServerManager.shared.httpUploadWithHeader(api: API_BASE_URL + "user/profile",method: .post, params: parameter, multipartObject: temp, successHandler: { (JSON) in
            ServerManager.shared.hidHud()
            if JSON["status"].intValue == 200{
//                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:JSON["message"].stringValue , cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
//                    let data = JSON["data"]
//                    let currentUser = User.init(userData: data)
//                    AppManager.saveLoggedInUser(currentUser: currentUser)
//                    AppManager.getLoggedInUser()
//                })
                
                
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
    
    func apiGetStripeUrl(){
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request: API_BASE_URL + "stripe-link-account", successHandler: { (response) in
            ServerManager.shared.hidHud()
            if response["status"].intValue == 200 {
                   let message = response["data"]["accountLink"]["url"].stringValue
                let controller = AppDelegate.getViewController(identifire: "StripeConnectVC") as! StripeConnectVC
                controller.accountUrl = message
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let message = response["message"].stringValue
                AlertToastManager.shared.addToast(self.view, message: message, position: .top)
            }
        }, failureHandler: { (error) in
            ServerManager.shared.hidHud()
            DispatchQueue.main.async {
                AlertToastManager.shared.addToast(self.view, message: error?.localizedDescription ?? "", position: .top)
                
            }
        }, progressHandler: { (progress) in
            print(progress as Any)
        })
    }
}
