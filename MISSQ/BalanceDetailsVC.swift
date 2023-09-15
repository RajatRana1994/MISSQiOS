//
//  BalanceDetailsVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 31/05/22.
//

import UIKit
import SwiftyJSON
class BalanceDetailsVC: UIViewController {
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblPHP: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tblData: UITableView!
    var arrData = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblPHP.text = "PHP"
        self.apiGetData(type: "1")
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTopUpAction(sender: UIButton){
        self.apiGetData(type: "1")
    }
    @IBAction func btnRequestAction(sender: UIButton){
        self.apiGetData(type: "4")
    }
    func apiGetData(type: String) {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "wallet-transection?limit=20&offset=1&transectionType=\(type)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let data = response["data"]
                self.lblPayment.text = "₱\(data["balance"].stringValue)"
                self.arrData = data["walletTransections"].arrayValue
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
                self.apiGetData(type: type)
            })
        } progressHandler: { (progress) in
            
        }
    }
}
extension BalanceDetailsVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.lblName.text = dict["text"].stringValue
        cell.lblDesc.text = "ID \(dict["id"].stringValue)"
        cell.lblDate.text = "\(dict["amount"].stringValue).00"
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
