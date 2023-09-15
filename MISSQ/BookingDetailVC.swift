//
//  BookingDetailVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift

class BookingDetailVC: UIViewController {
    @IBOutlet weak var viewApprovedMSg: UIView!
    @IBOutlet weak var viewTrack: UIView!
    @IBOutlet weak var lblTxn: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    var bookingID: String = ""
    var providerID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnReview.isHidden = true
        if self.accessibilityHint == "booking"{
            viewApprovedMSg.isHidden = false
            viewTrack.isHidden = false
        }else{
            viewApprovedMSg.isHidden = true
            viewTrack.isHidden = false
        }
        self.apiGetData()
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnGiveProviderREviewAction(sender: UIButton){
        
        let vc = AppDelegate.getViewController(identifire: "ReviewVC") as! ReviewVC
        vc.hidesBottomBarWhenPushed = true
        vc.bookingID = self.bookingID
        vc.userID = self.providerID
        vc.accessibilityHint = "user"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTrackAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "TrackOrderVC") as! TrackOrderVC
        vc.bookingID = self.bookingID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "booking/\(self.bookingID)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
               let dict = response["data"]
                self.providerID = dict["serviceProviderId"].stringValue
                self.lblDate.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingDate"].doubleValue, dt: "MMM dd, yyyy")
                self.lblName.text = dict["providerInfo"]["providerName"].stringValue
                self.lblPhone.text = dict["providerInfo"]["providerPhone"].stringValue
                self.lblAddress.text = dict["serviceProviderLocation"]["address"].stringValue //""//dict["providerInfo"]["providerPhone"].stringValue
                self.imgProfile.sd_setImage(with: URL(string: dict["serviceDetails"]["image"].stringValue), placeholderImage: UIImage(named: "app_logo"))
                self.lblServiceName.text = dict["serviceDetails"]["name"].stringValue
                
                self.lblStartTime.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingStartTime"].doubleValue, dt: "hh:mm a")
                self.lblEndTime.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingEndTime"].doubleValue, dt: "hh:mm a")
                let duration = dict["bookingEndTime"].doubleValue - dict["bookingStartTime"].doubleValue
                let durationMinutes = duration / 60
                var totalValue = Double(dict["serviceDetails"]["price"].stringValue)
                if Int(durationMinutes) % 60 == 0 &&  (Int(durationMinutes) < 60){
                    self.lblPrice.text = "\(dict["serviceDetails"]["price"].stringValue).00"
                    self.btnAmount.text = "\(CurrencyName) \(dict["serviceDetails"]["price"].stringValue).00"
                } else {
                    var count = Double((Int(durationMinutes) / 60)) * (totalValue ?? 0.0)
                    if (Int(durationMinutes) % 60) != 0 {
                        count = count + ((totalValue ?? 0) / 2)
                    }
                    
                    self.lblPrice.text = "\(CurrencyName) \(count)"
                    self.btnAmount.text = "\(CurrencyName) \(count)"
                    
                }
                self.lblDuration.text = "\(Int(durationMinutes)) \("minutes".localized())"
           //     self.btnAmount.setTitle("\(CurrencyName) \(dict["serviceDetails"]["price"].stringValue).00", for: .normal)
                
                let status = dict["status"].intValue
                if status == 1 || status == 2{
                     if self.accessibilityHint == "booking"{
                         self.lblStatus.text = "\("your_request_has_been".localized()) \(status == 1 ? "Approved".localized() : "Rejected".localized())"
                    }
                }else{
                    self.lblStatus.text = "\("your_request_has_been_log".localized())"
                }
                if status == 3 || status == 4{
                    self.btnReview.isHidden = false
                }else{
                    self.btnReview.isHidden = true
                }
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
}
