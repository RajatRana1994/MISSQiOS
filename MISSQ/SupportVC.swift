//
//  SupportVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 13/04/22.
//

import UIKit
import Localize_Swift

class SupportVC: UIViewController {
var arrData = ["Instagram","Facebook","Twitter","Professional association","A friend or colleague","Other(Please specify)"]
    var selectedIndex : Int = 0
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var tvAbout: UITextView!
    @IBOutlet weak var tvOther: UITextView!
    @IBOutlet weak var vweOther: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vweOther.isHidden = true
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitAction(sender: UIButton){
        if (tvAbout.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "Enter_something_interesting_about_you".localized(), position: .top)
        }else if  self.selectedIndex == 5 && (tvOther.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "Enter_specify_other_app_name".localized(), position: .top)
        }else{
            self.apiSubmitData()
        }
    }
    func apiSubmitData()  {
        var parameter = Dictionary<String, String>()
        parameter["text"] = self.tvAbout.text!
        parameter["type"] = "\(self.selectedIndex + 1)"
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "app-survey",type: .post, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: response["message"].stringValue, cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    self.navigationController?.popViewController(animated: true)
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
extension SupportVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.lblName.text = dict
        if indexPath.row == self.selectedIndex{
            cell.imgProfile.backgroundColor = UIColor.AppOrangeColor()
        }else{
            cell.imgProfile.backgroundColor = UIColor.white
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5{
            self.vweOther.isHidden = false
        }else{
            self.vweOther.isHidden = true
        }
        self.selectedIndex = indexPath.row
        self.tblData.reloadData()
    }
    
}
