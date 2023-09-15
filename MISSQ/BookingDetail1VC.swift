//
//  BookingDetail1VC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import SwiftUI

class BookingDetail1VC: UIViewController {
    @IBOutlet weak var sv: UIScrollView!
    
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblQuotedAmount: UILabel!
    @IBOutlet weak var lblCategory2: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var lblPaybleByCustomer: UILabel!
    @IBOutlet weak var lblAlreadyPaid: UILabel!
    @IBOutlet weak var lblOrderRewards: UILabel!
    @IBOutlet weak var lblCategory3: UILabel!
    @IBOutlet weak var lblCategory3Price: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblServiceSubtotal: UILabel!
    @IBOutlet weak var lblOrdertotal: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var BtnCompleteSetup: UIButton!
    @IBOutlet weak var BtnRequestStatus: UIButton!
    @IBOutlet weak var BtnRequestStatusHeight: NSLayoutConstraint!
    var bookingId : String = ""
    var dict = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerManager.shared.showHud()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.apiGetData()
    }
    func apiGetData() {
        
        ServerManager.shared.httpGet(request:API_BASE_URL + "booking/\(self.bookingId)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.dict = response["data"]
                self.lblCategory.text = self.dict["serviceDetails"]["name"].stringValue
                self.lblCategory2.text = self.dict["serviceDetails"]["name"].stringValue
                self.lblCategory3.text = self.dict["serviceDetails"]["name"].stringValue
                self.lblDateTime.text = "\(AppManager.convertTimeStampToDate(timeStamp: self.dict["bookingDate"].doubleValue, dt: "dd MMM hh:mm a"))"
                self.lblOrderID.text = "\("order_ID".localized()) #\(self.dict["id"].stringValue)"
                
                let price = "₱\(String(format:"%.2f", self.dict["serviceDetails"]["price"].doubleValue))"
                
                
                let duration = self.dict["bookingEndTime"].doubleValue - self.dict["bookingStartTime"].doubleValue
                let durationMinutes = duration / 60
                var totalValue = Double(self.dict["serviceDetails"]["price"].stringValue)
                if Int(durationMinutes) % 60 == 0 &&  (Int(durationMinutes) < 60){
                    self.lblPaybleByCustomer.text = price
                    self.lblCategory3Price.text = price
                    self.lblOrdertotal.text = price
                    self.lblQuotedAmount.text = price
                } else {
                    var count = Double((Int(durationMinutes) / 60)) * (totalValue ?? 0.0)
                    if (Int(durationMinutes) % 60) != 0 {
                        count = count + ((totalValue ?? 0) / 2)
                    }
                    
                    self.lblQuotedAmount.text = "\(CurrencyName) \(count)"
                    self.lblPaybleByCustomer.text = "\(CurrencyName) \(count)"
                    self.lblCategory3Price.text = "\(CurrencyName) \(count)"
                    self.lblOrdertotal.text = "\(CurrencyName) \(count)"
                   
                    
                }
                
                
                self.lblName.text = self.dict["userInfo"]["userName"].stringValue
                self.lblPhone.text = self.dict["userInfo"]["userPhone"].stringValue
                self.lblAddress.text = self.dict["userInfo"]["userAddress"].stringValue
                self.lblAddress2.text = self.dict["userInfo"]["userAddress"].stringValue
                self.lblAddress1.text = self.dict["userInfo"]["userAddress"].stringValue
                
                
                self.lblAlreadyPaid.text = "P0.0"
                self.lblOrderRewards.text = "P0.0"
                
                self.lblBalance.text = "P0.0"
                self.lblServiceSubtotal.text = "P0.0"
               
                self.lblStartTime.text = "\(AppManager.convertTimeStampToDate(timeStamp: self.dict["bookingStartTime"].doubleValue, dt: "hh:mm a"))"
                self.lblEndTime.text = "\(AppManager.convertTimeStampToDate(timeStamp: self.dict["bookingEndTime"].doubleValue, dt: "hh:mm a"))"
                
                
                
                let status = self.dict["status"].intValue
                let setUp = self.dict["setup"].intValue
                if status == 0{
                    self.BtnRequestStatus.isHidden = true
                    self.BtnRequestStatusHeight.constant = 0
                }else if status == 2{
                    self.BtnRequestStatus.isHidden = false
                    self.BtnRequestStatusHeight.constant = 45
                    self.BtnRequestStatus.setTitle("request_has_been_declined".localized(), for: .normal)
                }else{
                    self.BtnRequestStatus.isHidden = false
                    self.BtnRequestStatusHeight.constant = 45
                    self.BtnRequestStatus.setTitle("request_has_been_approved".localized(), for: .normal)
                }
                
                if self.dict["paymentType"].intValue == 1 {
                    self.lblPaymentType.text = "Cash"
                } else {
                    self.lblPaymentType.text = "Pay-Mongo"
                }
                if status == 1{
                    if setUp == 0 ||  setUp == 1 || setUp == 2 || setUp == 3{
                        self.btnAccept.isHidden = true
                        self.btnReject.isHidden = true
                        self.BtnCompleteSetup.isHidden = false
                        self.BtnCompleteSetup.setTitle("complete_setup".localized(), for: .normal)
                    }else if setUp == 4{
                        self.btnAccept.isHidden = true
                        self.btnReject.isHidden = true
                        self.BtnCompleteSetup.isHidden = false
                        self.BtnCompleteSetup.setTitle("completed".localized(), for: .normal)
                    }else{
                        self.btnAccept.isHidden = false
                        self.btnReject.isHidden = false
                        self.BtnCompleteSetup.isHidden = true
                    }
                }else if status == 3{
                    self.btnAccept.isHidden = true
                    self.btnReject.isHidden = true
                    self.BtnCompleteSetup.isHidden = false
                    self.BtnCompleteSetup.setTitle("completed".localized(), for: .normal)
                }else{
                    self.btnAccept.isHidden = false
                    self.btnReject.isHidden = false
                    self.BtnCompleteSetup.isHidden = true
                    
                }
                
                self.sv.isHidden = false
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
    
    @IBAction func btnContactChatAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "MessageDetailVC") as! MessageDetailVC
        vc.hidesBottomBarWhenPushed = true
        vc.bookingID = self.dict["id"].stringValue
        vc.opponentImage = self.dict["userInfo"]["userProfile"].stringValue
        vc.opponentID = self.dict["userId"].stringValue
        vc.bookingID = dict["id"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAcceptAction(sender: UIButton){
        self.apiAcceptRejectOrder(type: "1", idd: self.bookingId)
    }
    @IBAction func btnRejectAction(sender: UIButton){
        self.apiAcceptRejectOrder(type: "2", idd: self.bookingId)
    }
    func apiAcceptRejectOrder(type: String, idd: String)  {
        var parameter = Dictionary<String, String>()
        parameter["status"] = "\(type)"
        print(parameter)
        ServerManager.shared.showHud()
     ServerManager.shared.httpPost(request: API_BASE_URL + "accept-booking/\(idd)",type: .put, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
                self.apiGetData()
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
    @IBAction func btnCompleteSetupAction(sender: UIButton){
        let title = self.BtnCompleteSetup.titleLabel?.text ?? ""
        let setUp = self.dict["setup"].intValue
        if title == "Completed" && self.dict["isRated"].intValue == 0{
            let vc = AppDelegate.getViewController(identifire: "ReviewVC") as! ReviewVC
            vc.hidesBottomBarWhenPushed = true
            vc.bookingID = self.bookingId
            vc.userID = self.dict["userId"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title == "Complete Setup"{
            if self.dict["isPaymentDone"].intValue == 1 && self.dict["paymentType"].intValue == 2{
                if setUp == 0{
                    let vc = AppDelegate.getViewController(identifire: "LocationVC") as! LocationVC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 1{
                    let vc = AppDelegate.getViewController(identifire: "BookingDetail2VC") as! BookingDetail2VC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 2{
                    let vc = AppDelegate.getViewController(identifire: "BookingDetail3VC") as! BookingDetail3VC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 3{
                    let vc = AppDelegate.getViewController(identifire: "BookingDetail4VC") as! BookingDetail4VC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    vc.dict = self.dict
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 4  && self.dict["isRated"].intValue == 0{
                    let vc = AppDelegate.getViewController(identifire: "ReviewVC") as! ReviewVC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if self.dict["paymentType"].intValue == 1{
                if setUp == 0{
                    let vc = AppDelegate.getViewController(identifire: "LocationVC") as! LocationVC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 1{
                    let vc = AppDelegate.getViewController(identifire: "BookingDetail2VC") as! BookingDetail2VC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 2{
                    let vc = AppDelegate.getViewController(identifire: "BookingDetail3VC") as! BookingDetail3VC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 3{
                    let vc = AppDelegate.getViewController(identifire: "BookingDetail4VC") as! BookingDetail4VC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    vc.dict = self.dict
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if setUp == 4  && self.dict["isRated"].intValue == 0{
                    let vc = AppDelegate.getViewController(identifire: "ReviewVC") as! ReviewVC
                    vc.hidesBottomBarWhenPushed = true
                    vc.bookingID = self.bookingId
                    vc.userID = self.dict["userId"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:"Can't start service, Due to pending payment!", cancelButtonTitle: "Ok".localized(), destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
           
        }
        
    }
    
    
}
