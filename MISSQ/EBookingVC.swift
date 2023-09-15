//
//  EBookingVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import FSCalendar
class EBookingVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var arrData = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTodayBooking()
    }
    func getTodayBooking(){
        let todayDate = Date().format(with: "yyyy-MM-dd", locale: .current)
        let olDateFormatter = DateFormatter()
            olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let oldDate = olDateFormatter.date(from: "\(todayDate) 23:59")
        self.apiGetData(isPast: "true", date: Int(oldDate?.timeIntervalSince1970 ?? 0))
    }
    func apiGetData(isPast: String, date:Int) {
        ServerManager.shared.showHud()
        //"get-bookings?limit=50&page=1&date=\(date)&isPast=\(isPast)"
        ServerManager.shared.httpGet(request:API_BASE_URL + "get-bookings?limit=50&page=1&date=\(date)&isPast=\(isPast)") { (response) in
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
                self.apiGetData(isPast: isPast, date: date)
            })
        } progressHandler: { (progress) in
            
        }
    }
    
    @objc func btnAccept(sender: UIButton){
        let dict = self.arrData[sender.tag]
        self.apiAcceptRejectOrder(type: "1", idd: dict["id"].stringValue)
    }
    @objc func btnReject(sender: UIButton){
        let dict = self.arrData[sender.tag]
        self.apiAcceptRejectOrder(type: "2", idd: dict["id"].stringValue)
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
             _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: response["message"].stringValue, cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                 self.getTodayBooking()
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
extension EBookingVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.lblName.text = dict["serviceDetails"]["name"].stringValue
        cell.lblAddress.text = dict["userInfo"]["userAddress"].stringValue
        cell.lblDesc.text = dict["userInfo"]["userAddress"].stringValue
        cell.lblTime.text = "\(AppManager.convertTimeStampToDate(timeStamp: dict["bookingStartTime"].doubleValue, dt: "hh:mm a"))"
        cell.lblDate.text = "\(AppManager.convertTimeStampToDate(timeStamp: dict["bookingEndTime"].doubleValue, dt: "hh:mm a"))"
        let status = dict["status"].intValue
        let setup = dict["setup"].intValue
        if status == 0{
            cell.btnAccept.isHidden = false
            cell.btnDelete.isHidden = false
            cell.btnAccept.isUserInteractionEnabled = true
            cell.btnDelete.isUserInteractionEnabled = true
            cell.trailingConstraint.constant = 85
            cell.btnAccept.setTitle("accept".localized(), for: .normal)
            cell.btnDelete.setTitle("reject".localized(), for: .normal)
        }else if status == 3 && setup == 4{
            cell.btnDelete.isHidden = true
            cell.btnAccept.isHidden = false
            cell.trailingConstraint.constant = 10
            cell.btnAccept.setTitle("completed".localized(), for: .normal)
            cell.btnAccept.isUserInteractionEnabled = false
            cell.btnDelete.isUserInteractionEnabled = false
        }else if status == 2{
            cell.btnDelete.isHidden = true
            cell.btnAccept.isHidden = true
            cell.btnAccept.isUserInteractionEnabled = false
            cell.btnDelete.isUserInteractionEnabled = false
        }else{
            cell.btnDelete.isHidden = true
            cell.btnAccept.isHidden = false
            cell.trailingConstraint.constant = 10
            cell.btnAccept.setTitle("on_going".localized(), for: .normal)
            cell.btnAccept.isUserInteractionEnabled = false
            cell.btnDelete.isUserInteractionEnabled = false
        }
        cell.btnAccept.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(self.btnAccept(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.btnReject(sender:)), for: .touchUpInside)
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrData[indexPath.row]
        let vc = AppDelegate.getViewController(identifire: "BookingDetail1VC") as! BookingDetail1VC
        vc.hidesBottomBarWhenPushed = true
        vc.bookingId = dict["id"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension EBookingVC: FSCalendarDelegate,FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date.isToday{
            self.getTodayBooking()
        }else if date.isEarlier(than: Date()){
            print("Earlier")
            let todayDate = date.format(with: "yyyy-MM-dd", locale: .current)
            let olDateFormatter = DateFormatter()
                olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let oldDate = olDateFormatter.date(from: "\(todayDate) 23:59")
            self.apiGetData(isPast: "true", date: Int(oldDate?.timeIntervalSince1970 ?? 0))
        }else{
            let todayDate = date.format(with: "yyyy-MM-dd", locale: .current)
            let todayTime = Date().format(with: "HH:mm", locale: .current)
            let olDateFormatter = DateFormatter()
                olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let oldDate = olDateFormatter.date(from: "\(todayDate) \(todayTime)")
            self.apiGetData(isPast: "false", date: Int(oldDate?.timeIntervalSince1970 ?? 00))
        }
    }
}
