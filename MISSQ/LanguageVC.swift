//
//  LanguageVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 14/04/22.
//

import UIKit
import Localize_Swift

class LanguageVC: UIViewController {
    @IBOutlet weak var tblData: UITableView!
    var selectedIndex: Int = 0
    var arrData = ["ENGLISH","SPANISH","CHINESE","FRENCH"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tblData.viewborderAndRound(color: UIColor.lightGray, radius: 12)
        if Localize.currentLanguage() == "en" {
            selectedIndex = 0
        }else if Localize.currentLanguage() == "es" {
            selectedIndex = 1
        }else if Localize.currentLanguage() == "zh-HK" {
            selectedIndex = 2
        }else if Localize.currentLanguage() == "fr" {
            selectedIndex = 3
        }
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
extension LanguageVC:UITableViewDelegate,UITableViewDataSource{
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
        cell.lblName.text = self.arrData[indexPath.row]
        if indexPath.row == self.selectedIndex{
            cell.imgProfile.layer.borderColor = UIColor.AppColor().cgColor
            cell.imgProfile.layer.borderWidth = 1
            cell.imgProfile.backgroundColor = UIColor.black
            cell.lblName.textColor = UIColor.white
            cell.vweBase.backgroundColor = UIColor.black
        }else{
            cell.imgProfile.layer.borderColor = UIColor.black.cgColor
            cell.imgProfile.layer.borderWidth = 1
            cell.imgProfile.backgroundColor = UIColor.AppColor()
            cell.lblName.textColor = UIColor.white
            cell.vweBase.backgroundColor = UIColor.clear
        }
       
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        if indexPath.row == 0{
            Localize.setCurrentLanguage("en")
        }else if indexPath.row == 1{
            Localize.setCurrentLanguage("es")
        }else if indexPath.row == 2{
            Localize.setCurrentLanguage("zh-HK")
        }else if indexPath.row == 3{
            Localize.setCurrentLanguage("fr")
        }
        if loggedInUser.loginType == "1"{
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetEmployeeTabbarController()
        }else{
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetTabbarController()
        }
        tblData.reloadData()
    }
}
