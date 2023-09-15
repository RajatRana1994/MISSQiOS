//
//  BookingDetail4VC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class BookingDetail4VC: UIViewController {
    @IBOutlet weak var lblOrderContact: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblprice: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var lblPAybleByCustomer: UILabel!
    
    var bookingID: String = ""
    var userID: String = ""
    var dict = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblOrderContact.text = "\("order_contact".localized()): \(self.dict["userInfo"]["userPhone"].stringValue)"
        self.lblDateTime.text = "\(AppManager.convertTimeStampToDate(timeStamp: self.dict["bookingDate"].doubleValue, dt: "dd MMM hh:mm a"))"
        let price = "₱\(String(format:"%.2f", self.dict["serviceDetails"]["price"].doubleValue))"
        
        
        let duration = self.dict["bookingEndTime"].doubleValue - self.dict["bookingStartTime"].doubleValue
        let durationMinutes = duration / 60
        var totalValue = Double(self.dict["serviceDetails"]["price"].stringValue)
        if Int(durationMinutes) % 60 == 0 &&  (Int(durationMinutes) < 60){
            self.lblprice.text = price
            self.lblPAybleByCustomer.text = price
        } else {
            var count = Double((Int(durationMinutes) / 60)) * (totalValue ?? 0.0)
            if (Int(durationMinutes) % 60) != 0 {
                count = count + ((totalValue ?? 0) / 2)
            }
            
            self.lblprice.text = "₱ \(count)"
            self.lblPAybleByCustomer.text = "₱ \(count)"
           
           
            
        }
        
        
        lblName1.text = self.dict["userInfo"]["userName"].stringValue
        lblAddress1.text = self.dict["userInfo"]["userAddress"].stringValue
        lblName2.text = loggedInUser.username
        lblAddress2.text = self.dict["serviceProviderLocation"]["address"].stringValue
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCallAction(sender: UIButton){
        let phone = self.dict["userInfo"]["userPhone"].stringValue
        AppManager.makeCallByPhoneNumber(dateString: phone)
    }
    @IBAction func btnNaviagteAction(sender: UIButton){
        let lattittude = self.dict["serviceProviderLocation"]["latitude"].stringValue
        let longitude = self.dict["serviceProviderLocation"]["longitude"].stringValue
    }
    @IBAction func btnAcceptAction(sender: UIButton){
        self.apiSubmitData()
    }
    
    @IBAction func btnChatAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "MessageDetailVC") as! MessageDetailVC
        vc.hidesBottomBarWhenPushed = true
        vc.opponentImage = dict["userInfo"]["userProfile"].stringValue
        vc.opponentID = dict["userId"].stringValue
        vc.bookingID = dict["id"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func apiSubmitData()  {
        var parameter = Dictionary<String, String>()
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "booking/\(self.bookingID)/4",type: .put, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
                let vc = AppDelegate.getViewController(identifire: "ReviewVC") as! ReviewVC
                vc.hidesBottomBarWhenPushed = true
                vc.bookingID = self.bookingID
                vc.userID = self.userID
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

}
