//
//  BookingDetail2VC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class BookingDetail2VC: UIViewController {
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblCahToConvert: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    var bookingID: String = ""
    var userID: String = ""
    var dict = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerManager.shared.showHud()
        self.apiGetData()
    }
    func apiGetData() {
        
        ServerManager.shared.httpGet(request:API_BASE_URL + "booking/\(self.bookingID)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.dict = response["data"]
               
                self.lblOrderID.text = "\("order_ID".localized()) #\(self.dict["id"].stringValue)"
                
                
                
                let price = "₱\(String(format:"%.2f", self.dict["serviceDetails"]["price"].doubleValue))"
                
                
                let duration = self.dict["bookingEndTime"].doubleValue - self.dict["bookingStartTime"].doubleValue
                let durationMinutes = duration / 60
                var totalValue = Double(self.dict["serviceDetails"]["price"].stringValue)
                if Int(durationMinutes) % 60 == 0 &&  (Int(durationMinutes) < 60){
                    self.lblCahToConvert.text = price
                    self.lblTotalAmount.text = price
                } else {
                    var count = Double((Int(durationMinutes) / 60)) * (totalValue ?? 0.0)
                    if (Int(durationMinutes) % 60) != 0 {
                        count = count + ((totalValue ?? 0) / 2)
                    }
                    
                    self.lblCahToConvert.text = "₱ \(count)"
                    self.lblTotalAmount.text = "₱ \(count)"
                   
                }
                
                //let price = "₱\(String(format:"%.2f", self.dict["serviceDetails"]["price"].doubleValue))"
                
                self.lblName.text = self.dict["userInfo"]["userName"].stringValue
                self.lblPhone.text = self.dict["userInfo"]["userPhone"].stringValue
                self.lblAddress.text = self.dict["userInfo"]["userAddress"].stringValue
               
                
                
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
    @IBAction func btnCallAction(sender: UIButton){
        let phone = self.dict["userInfo"]["userPhone"].stringValue
        AppManager.makeCallByPhoneNumber(dateString: phone)
    }
    @IBAction func btnNaviagteAction(sender: UIButton){
        let lattittude = self.dict["serviceProviderLocation"]["latitude"].doubleValue
        let longitude = self.dict["serviceProviderLocation"]["longitude"].doubleValue
        
            
              if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

                  if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lattittude),\(longitude)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:])
                   }}
              else {
                     //Open in browser
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lattittude),\(longitude)&directionsmode=driving") {
                                       UIApplication.shared.open(urlDestination)
                                   }
                        }

                }
    @IBAction func btnSwitchAction(sender: UISwitch){
        
    }
    @IBAction func btnAcceptAction(sender: UIButton){
        self.apiSubmitData()
    }
    func apiSubmitData()  {
        var parameter = Dictionary<String, String>()
        parameter["isContactedClient"] = self.btnSwitch.isOn ? "1" : "0"
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "booking/\(self.bookingID)/2",type: .put, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
                let vc = AppDelegate.getViewController(identifire: "BookingDetail3VC") as! BookingDetail3VC
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
