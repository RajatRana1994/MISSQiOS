//
//  CustomerBookingVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class CustomerBookingVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var arrData = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerManager.shared.showHud()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.apiGetData()
        AppManager.getLoggedInUser()
        
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
    
    @objc func DoPaymentMethod(sender:UIButton){
        let dict = self.arrData[sender.tag]
        
        
        let price = "₱\(String(format:"%.2f", dict["serviceDetails"]["price"].doubleValue))"
        
        
        let duration = dict["bookingEndTime"].doubleValue - dict["bookingStartTime"].doubleValue
        let durationMinutes = duration / 60
        var totalValue = Double(dict["serviceDetails"]["price"].stringValue)
        if Int(durationMinutes) % 60 == 0 &&  (Int(durationMinutes) < 60){
            self.apiPaymentCharge(amount: dict["totalPrice"].doubleValue, bookingID: dict["id"].stringValue)
        } else {
            var count = Double((Int(durationMinutes) / 60)) * (totalValue ?? 0.0)
            if (Int(durationMinutes) % 60) != 0 {
                count = count + ((totalValue ?? 0) / 2)
            }
            
            self.apiPaymentCharge(amount: count, bookingID: dict["id"].stringValue)
        }
       
    }
    func apiPaymentCharge(amount: Double, bookingID: String)  {
            var parameter = Dictionary<String, String>()
            parameter["amount"] = "\(amount * 100)"
        parameter["userId"] = AppManager.getUserID()
        parameter["bookingId"] = bookingID
            print(parameter)
            ServerManager.shared.showHud()
         ServerManager.shared.httpPost(request: API_BASE_URL + "payment-intent-paymongo",type: .post, params: parameter, successHandler: { (response) in
                print(response)
                ServerManager.shared.hidHud()
                AlertManager.shared.hideErrorView()
             let checkOutUrl = response["data"]["paymongo"]["data"]["attributes"]["checkout_url"].stringValue
                if response["status"].intValue == 200 {
                   
                    let vc = AppDelegate.getViewController(identifire: "PaymentWebviewVC") as! PaymentWebviewVC
                    vc.hidesBottomBarWhenPushed = true
                    vc.accountUrl = checkOutUrl
                    vc.isTopUp = false
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
    
    func apiPaymentApi(json: String, amount: String, bookingID:String)  {
        var parameter = Dictionary<String, String>()
        parameter["amount"] = "\(amount)"
        parameter["paymentDetails"] = "\(json)"
        print(parameter)
        ServerManager.shared.showHud()
     ServerManager.shared.httpPost(request: API_BASE_URL + "stripe-payment-done/\(bookingID)",type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
             _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: response["message"].stringValue, cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                 self.apiGetData()
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
extension CustomerBookingVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.lblName.text = "\("client".localized()): \(dict["providerInfo"]["providerName"].stringValue)"
        cell.lblDesc.text = "\(dict["serviceDetails"]["name"].stringValue)"
        cell.lblTrackingID.text = "\("employee".localized()) #: \(dict["serviceProviderId"].stringValue)"
        cell.lblEmployeeID.text = "\("tracking".localized()) #: \(dict["serviceId"].stringValue)"
        cell.lblDesc.text = "\(dict["serviceDetails"]["name"].stringValue)"
        cell.lblTime.text = "\("start".localized()): \(AppManager.convertTimeStampToDate(timeStamp: dict["bookingStartTime"].doubleValue, dt: "hh:mm a"))"
        cell.lblAddress.text = "\("address".localized()): "
        cell.imgProfile.sd_setImage(with: URL(string: dict["serviceDetails"]["image"].stringValue), placeholderImage: UIImage(named: "app_logo"))
        if dict["paymentType"].intValue == 2 && dict["isAccept"].intValue == 1 && dict["isPaymentDone"].intValue == 0{
            cell.btnAccept.isHidden = false
        }else{
            cell.btnAccept.isHidden = true
        }
        cell.btnAccept.tag  = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(self.DoPaymentMethod(sender:)), for: .touchUpInside)
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrData[indexPath.row]
        let vc = AppDelegate.getViewController(identifire: "BookingDetailVC") as! BookingDetailVC
        vc.hidesBottomBarWhenPushed = true
        vc.accessibilityHint = "booking"
        vc.bookingID = dict["id"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
