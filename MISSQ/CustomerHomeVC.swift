//
//  CustomerHomeVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class CustomerHomeVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var arrData = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        //http://54.169.185.218/apis/v1/get-bookings?limit=20&page=1
       // 54.169.185.218/apis/v1/booking/5
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedNotification), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        ServerManager.shared.showHud()
        
    }
    //MARK:- GET NOTIFICATION CHAT DATA
    @objc func tappedNotification(notification: Notification){
        
        if AppDelegate.sharedDelegate.notificationCode == "1" || AppDelegate.sharedDelegate.notificationCode == "2"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: nil)
                
            }
        }
        if AppDelegate.sharedDelegate.notificationCode == "8"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tabBarController?.selectedIndex = 2
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
    override func viewWillAppear(_ animated: Bool) {
        self.apiGetData()
        AppManager.getLoggedInUser()
        self.lblName.text = "\("hi".localized()), " + loggedInUser.username
        self.btnProfile.sd_setImage(with: URL(string: loggedInUser.image ), for: .normal)
    }
    func apiGetData() {
        
        ServerManager.shared.httpGet(request:API_BASE_URL + "get-bookings?limit=50&page=1") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.arrData = response["data"]["bookings"].arrayValue
                if self.arrData.count == 0{
                    self.tblData.isHidden = true
                    self.lblNoDataFound.isHidden = false
                }else{
                    self.tblData.isHidden = false
                    self.lblNoDataFound.isHidden = true
                }
                self.tblData.delegate = self
                self.tblData.dataSource = self
                self.tblData.reloadData()
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
    @IBAction func btnProfileAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "CustomerProfileVC") as! CustomerProfileVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBookServiceAction(sender: UIButton){
        
        let vc = AppDelegate.getViewController(identifire: "BookServiceVC") as! BookServiceVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension CustomerHomeVC:UITableViewDelegate,UITableViewDataSource{
    //MARK:Table view Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath)as! CommonCell
        cell.selectionStyle = .none
        let dict = self.arrData[indexPath.row]
        cell.lblDate.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingDate"].doubleValue, dt: "MMM dd, yyyy")
        cell.lblName.text = dict["serviceDetails"]["name"].stringValue
        cell.lblDesc.text = "RFG \(dict["serviceDetails"]["id"].stringValue)"
        cell.imgProfile.sd_setImage(with: URL(string: dict["serviceDetails"]["image"].stringValue), placeholderImage: UIImage(named: "app_logo"))
        let status = dict["status"].intValue
        if status == 0{
            cell.lblStatus.text = "pending".localized()
        }else if status == 1{
            cell.lblStatus.text = "on-going".localized()
        }else{
            cell.lblStatus.text = "completed".localized()
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrData[indexPath.row]
        let vc = AppDelegate.getViewController(identifire: "BookingDetailVC") as! BookingDetailVC
        vc.hidesBottomBarWhenPushed = true
        vc.bookingID = dict["id"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
