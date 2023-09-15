//
//  CheckOutVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class CheckOutVC: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPrice2: UILabel!
    @IBOutlet weak var imgCheckCash: UIImageView!
    @IBOutlet weak var imgCheckCard: UIImageView!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfStartTime: UITextField!
    @IBOutlet weak var tfEndTime: UITextField!
    
    var cardType: Int?
    var dateSelected : Int = 0
    var startTime : Int = 0
    var EndTime : Int = 0
    var dict = JSON()
    var apiCount = 0
    var bookingId: String = ""
    var wantToHit: Bool = true
    var alert: UIAlertController?
    var startTimeDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.sd_setImage(with: URL(string: dict["image"].stringValue), placeholderImage: UIImage(named: "app_logo"))
        self.lblService.text = dict["name"].stringValue
        self.lblPrice.text = "₱ \(dict["price"].stringValue).00"
        self.lblPrice2.text = "₱ \(dict["price"].stringValue).00"
        self.setDatePicker()
        self.setStartTimePicker()
        self.setEndTimePicker()
        tfDate.delegate = self
        tfStartTime.delegate = self
        tfEndTime.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedNotification), name: NSNotification.Name(rawValue: "NotificationIdentifier1"), object: nil)
    }
    
    @objc func tappedNotification(notification: Notification){
        wantToHit = false
        apiCount = 0
        alert?.dismiss(animated: false)
        
        //  self.tabBarController?.selectedIndex = 1
          self.alert = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: "Your booking request is accepted successfully. To see the booking please click on Bookings.", cancelButtonTitle: "Booking", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
              self.tabBarController?.selectedIndex = 1
              self.navigationController?.popToRootViewController(animated: false)
              
              
              
          })
    }
    func setDatePicker(){
        let picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.minimumDate = Date()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        tfDate.inputView = picker
        tfDate.placeholder = "Select Date"
    }
    func setStartTimePicker(){
        let picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
       // picker.maximumDate = Date()
        
        picker.datePickerMode = .time
        picker.minuteInterval = 30
        picker.addTarget(self, action: #selector(startTimeChanged(_:)), for: .valueChanged)
        tfStartTime.inputView = picker
        tfEndTime.placeholder = "Select Start Time"
    }
    func setEndTimePicker(){
        let picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 1, to: startTimeDate)
        picker.minimumDate = date
        picker.minuteInterval = 30
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(endTimeChanged(_:)), for: .valueChanged)
        tfEndTime.inputView = picker
        tfEndTime.placeholder = "Select End Time"
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        let dt = DateFormatter()
        dt.dateFormat = "dd/MM/yyyy"
        self.dateSelected = Int(sender.date.timeIntervalSince1970)
        self.tfDate.text = dt.string(from: sender.date)
        
    }
    @objc func startTimeChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        let dt = DateFormatter()
        dt.dateFormat = "hh:mm a"
        self.EndTime  = 0
        self.tfEndTime.text = ""
        self.startTime = Int(sender.date.timeIntervalSince1970)
        self.tfStartTime.text = dt.string(from: sender.date)
        self.startTimeDate = sender.date
        self.setEndTimePicker()
    }
    @objc func endTimeChanged(_ sender: UIDatePicker) {
        let dt = DateFormatter()
        dt.dateFormat = "hh:mm a"
        self.EndTime = Int(sender.date.timeIntervalSince1970)
        self.tfEndTime.text = dt.string(from: sender.date)
        
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPlaceOrderAction(sender: UIButton){
        let startt = (self.startTime)
        let endt = (self.EndTime)
        
        if self.dateSelected == 0{
            AlertToastManager.shared.addToast(self.view, message: "please_select_date".localized(), position: .top)
        }else if self.startTime == 0{
            AlertToastManager.shared.addToast(self.view, message: "please_select_start_time".localized(), position: .top)
        }else if self.EndTime == 0{
            AlertToastManager.shared.addToast(self.view, message: "please_select_end_time".localized(), position: .top)
        }else if (endt - startt) <= 0{
            AlertToastManager.shared.addToast(self.view, message: "end_time_must_be_greater_then_start_time".localized(), position: .top)
        }else{
            self.apiPlaceOrder()
        }
    }
    @IBAction func btnSelectPayByCashAction(sender: UIButton){
        self.cardType = 1
        self.imgCheckCard.isHidden = true
        self.imgCheckCash.isHidden = false
    }
    @IBAction func btnSelectPayByCreditCardAction(sender: UIButton){
        self.cardType = 2
        self.imgCheckCard.isHidden = false
        self.imgCheckCash.isHidden = true
    }
    func apiPlaceOrder()  {
        self.wantToHit = true
        self.apiCount = 0
        
        let startt = (self.startTime) / 60
        let endt = (self.EndTime) / 60
        let duration = (endt - startt)
        var parameter = Dictionary<String, String>()
        parameter["duration"] = "\(duration)"
        parameter["serviceId"] = self.dict["id"].stringValue
        parameter["bookingDate"] = "\(self.dateSelected)"
        parameter["bookingStartTime"] = "\(self.startTime)"
        parameter["bookingEndTime"] = "\(self.EndTime)"
        //   parameter["serviceProviderId"] = self.dict["providerId"].stringValue
        parameter["paymentType"] = "\(self.cardType ?? 1)"
        parameter["latitude"] =  AppDelegate.sharedDelegate.latitute
        parameter["longitude"] = AppDelegate.sharedDelegate.longitude
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "book/service",type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            self.bookingId = "\(response["data"]["id"].intValue )"
            if response["status"].intValue == 200 {
                self.alert = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: "Please wait for sometime we are looking for best service provider. We will update you one we will found good match for your service.", cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    self.navigationController?.popToRootViewController(animated: false)
                    
                })
                self.nextApiCall()
            }else{
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: "Sorry No provider available in this time, Please try later", cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                })
            }
        }){ (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                // self.GetStateFunction(countryIdd: countryIdd)
            })
        }
    }
    
    func nextApiCall() {
        if apiCount != 3 {
            //https://app.msqassociates.com/apis/v1/book/find-provider/198?distance=50
            let seconds = 120.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if self.wantToHit == true {
                    ServerManager.shared.httpGet(request: API_BASE_URL + "book/find-provider/\(self.bookingId)?distance=50") { response in
                        ServerManager.shared.hidHud()
                        AlertManager.shared.hideErrorView()
                        
                        if response["status"].intValue == 200 {
                            self.apiCount = self.apiCount + 1
                            self.nextApiCall()
                        }else{
                            
                            self.alert?.dismiss(animated: false)
                            _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: "Sorry No provider available in this time, Please try later.", cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                            })
                        }
                    } failureHandler: { error in
                        ServerManager.shared.hidHud()
                        AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                            // self.GetStateFunction(countryIdd: countryIdd)
                        })
                    } progressHandler: { progress in
                        
                    }
                }
            }
        }
    }
}
extension CheckOutVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.setDatePicker()
    }
}
