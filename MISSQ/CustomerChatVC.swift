//
//  CustomerChatVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class CustomerChatVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var arrData = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.apiGetData()
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "last-chat") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.arrData = response["data"].arrayValue
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

}
extension CustomerChatVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.imgProfile.sd_setImage(with: URL(string: dict["friendInfo"]["profile"].stringValue), placeholderImage: UIImage(named: "app_logo"))
        cell.lblName.text = dict["friendInfo"]["name"].stringValue
        cell.lblDesc.text = dict["message"].stringValue
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrData[indexPath.row]
        let vc = AppDelegate.getViewController(identifire: "MessageDetailVC") as! MessageDetailVC
        vc.hidesBottomBarWhenPushed = true
        vc.opponentImage = dict["friendInfo"]["profile"].stringValue
        if AppManager.getUserID() == dict["sender_id"].stringValue {
            vc.opponentID = dict["receiver_id"].stringValue
        } else {
            vc.opponentID = dict["sender_id"].stringValue
        }
        vc.bookingID = dict["bookingId"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
