//
//  TermsConditionVC.swift
//  Pool Pro
//
//  Created by Vikas Kumar on 04/03/22.
//

import UIKit

class TermsConditionVC: UIViewController {
    @IBOutlet weak var tvView: UITextView!
    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvView.text = ""
        if self.accessibilityHint == "policy"{
            self.lblTitle.text = "privacyPolicy".localized()
        }else{
            self.lblTitle.text = "termsConditions".localized()
        }
        self.apiGetData()
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "app-information") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let data = response["data"].arrayValue
                if self.accessibilityHint == "policy"{
                    if data.count > 0{
                        self.tvView.text = data[0]["value"].stringValue
                    }
                }else{
                    if data.count > 0{
                        self.tvView.text = data[1]["value"].stringValue
                    }
                }
                
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["msg"].stringValue, position: .top)
                
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
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
