//
//  ProviderListVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class ProviderListVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var arrData = [JSON]()
    var serviceID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiGetData()
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "provider-services?page=1&limit=20&latitude=0&longitude=0&distance=10000") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.arrData = response["data"]["result"].arrayValue
                if self.arrData.count == 0{
                    self.tblData.isHidden = true
                    self.lblNoDataFound.isHidden = false
                }else{
                    self.tblData.isHidden = false
                    self.lblNoDataFound.isHidden = true
                }
                self.arrData = self.arrData.filter({ (dt) in
                    return dt["id"].stringValue == self.serviceID
                })
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
extension ProviderListVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.imgProfile.sd_setImage(with: URL(string: dict["providerImage"].stringValue), placeholderImage: UIImage(named: "app_logo"))
        cell.lblName.text = dict["providerName"].stringValue
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrData[indexPath.row]
        let vc = AppDelegate.getViewController(identifire: "CheckOutVC") as! CheckOutVC
        vc.hidesBottomBarWhenPushed = true
        vc.dict = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
