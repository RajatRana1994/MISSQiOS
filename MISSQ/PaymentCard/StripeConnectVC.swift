//
//  VPAddBankAccountVC.swift
//  ValetIT
//
//  Created by ChandraPrakash on 23/06/21.
//

import UIKit
import WebKit

class StripeConnectVC: UIViewController {
    
    //MARK:- Variables
    var webview = WKWebView()
    var accountUrl = String()
    var accountID = String()
    
    //MARK:- Variable
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- UIButton Actions
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- setInitialData()
    func loadWebView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.webview.frame = self.view.frame
        }
        self.webview.navigationDelegate = self
        self.view.addSubview(self.webview)
        self.webview.load(NSURLRequest(url: NSURL(string: "\(self.accountUrl)")! as URL) as URLRequest)
    }
    
   
   
}

extension StripeConnectVC : WKNavigationDelegate{
    
    // MARK: - WebView delegate .
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        //    MBProgressHUD.showAdded(to: self.view, animated: true)
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("finish to load")
        let url = webView.url
        
        if url?.absoluteString.contains("http://35.182.146.148") ?? false && url?.absoluteString.contains("stripeAccountId") ?? false{
           
            _ =  UIAlertController.showAlertInViewController(viewController: self, withTitle: kAlertTitle, message: "Congrats, Stripe Connect Account created successfully!", cancelButtonTitle: "Continue", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (alert, action, intVal) in
                let user = loggedInUser
                user?.stripeId = " "
                AppManager.saveLoggedInUser(currentUser: user!)
                AppManager.getLoggedInUser()
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
     func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let res = navigationResponse.response as! HTTPURLResponse
        let header = res.allHeaderFields
        print(header)
        decisionHandler(.allow)
    }
}
extension StripeConnectVC {
    func apiGetStripeMessage(view: UIView, url:String ,handler: @escaping ((_ message : String,_ isSucess : Bool )->Void)){
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request: url, successHandler: { (response) in
            ServerManager.shared.hidHud()
            if response["status"].intValue == 200 {
                   let message = response["message"].stringValue
                    handler(message, true)
            }else{
                let message = response["message"].stringValue
                                   handler(message, false)
            }
        }, failureHandler: { (error) in
            ServerManager.shared.hidHud()
            DispatchQueue.main.async {
                AlertToastManager.shared.addToast(self.view, message: error?.localizedDescription ?? "", position: .top)
                
            }
        }, progressHandler: { (progress) in
            print(progress as Any)
        })
    }
}
