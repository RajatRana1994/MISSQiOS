//
//  TrackOrderVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class TrackOrderVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTracking: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var bookingID: String = ""
    var dict = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiGetData()
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "booking/\(self.bookingID)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.dict = response["data"]
                self.lblName.text = "\(self.dict["providerInfo"]["providerName"].stringValue)"
                self.lblAddress.text = self.dict["serviceProviderLocation"]["address"].stringValue
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
}
extension TrackOrderVC:UITableViewDelegate,UITableViewDataSource{
    //MARK:Table view Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath)as! CommonCell
        cell.selectionStyle = .none
        cell.btnAccept.isSelected = false
        if indexPath.row == 0{
            cell.uperLine.isHidden = true
            cell.lowerLine.isHidden = false
            cell.lblName.text = "completed".localized()
            cell.lblDesc.text = ""
            cell.lblDate.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingDate"].doubleValue, dt: "MMM dd, yyyy")
            cell.lblTime.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingEndTime"].doubleValue, dt: "hh:mm a")
        }else if indexPath.row == 1{
            cell.uperLine.isHidden = false
            cell.lowerLine.isHidden = false
            cell.lblName.text = "on_the_way".localized()
            cell.lblDesc.text = "your_employee_is_arriving_soon".localized()
            cell.lblDate.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingDate"].doubleValue, dt: "MMM dd, yyyy")
            cell.lblTime.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingStartTime"].doubleValue, dt: "hh:mm a")
        }else if indexPath.row == 2{
            cell.uperLine.isHidden = false
            cell.lowerLine.isHidden = false
            cell.lblName.text = "travelling".localized()
            cell.lblDesc.text = "your_employee_is_arriving_soon".localized()
            cell.lblDate.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingDate"].doubleValue, dt: "MMM dd, yyyy")
            cell.lblTime.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingStartTime"].doubleValue, dt: "hh:mm a")
        }else if indexPath.row == 3{
            cell.uperLine.isHidden = false
            cell.lowerLine.isHidden = true
            cell.lblName.text = "place_service".localized()
            cell.lblDesc.text = "your_request_has_been_log".localized()
            cell.btnAccept.isSelected = true
            cell.lblDate.text = AppManager.convertTimeStampToDate(timeStamp: dict["created"].doubleValue, dt: "MMM dd, yyyy")
            cell.lblTime.text = AppManager.convertTimeStampToDate(timeStamp: dict["bookingStartTime"].doubleValue, dt: "hh:mm a")
        }
        let status = self.dict["status"].intValue
        if status == 2{
            cell.btnAccept.isSelected = false
        } else if status == 3 {
            cell.btnAccept.isSelected = true
        }else{
            cell.btnAccept.isSelected = false
            if indexPath.row == 0 && status == 4{
                cell.btnAccept.isSelected = true
            }else if indexPath.row == 1 && status >= 1{
                cell.btnAccept.isSelected = true
            }else if indexPath.row == 2 && status >= 1{
                cell.btnAccept.isSelected = true
            }else if indexPath.row == 3{
                cell.btnAccept.isSelected = true
            }
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
