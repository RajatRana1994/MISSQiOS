//
//  PaymentWebviewVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 20/09/22.
// Congrats, Topup process completed successfully!, Balance will be added in few minutes.

import UIKit
import WebKit
class PaymentWebviewVC: UIViewController {
    
    //MARK:- Variables
    @IBOutlet weak var webview : WKWebView!
    var accountUrl = String()
    var accountID = String()
    var isTopUp: Bool = false
    //MARK:- Variable
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebView()
        ServerManager.shared.showHud()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let timer2 = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.getInnerHTml()
        }
    }
    
    //MARK:- UIButton Actions
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- setInitialData()
    func loadWebView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
          //  self.webview.frame = self.view.frame
        }
        self.webview.navigationDelegate = self
        //self.view.addSubview(self.webview)
        self.webview.load(NSURLRequest(url: NSURL(string: "\(self.accountUrl)")! as URL) as URLRequest)
    }
    
   
   
}

extension PaymentWebviewVC : WKNavigationDelegate{
    
    // MARK: - WebView delegate .
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        ServerManager.shared.hidHud()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        //    MBProgressHUD.showAdded(to: self.view, animated: true)
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("finish to load")
        ServerManager.shared.hidHud()
        let url = webView.url
        
        if url?.absoluteString.contains("http://54.169.185.218") ?? false && url?.absoluteString.contains("stripeAccountId") ?? false{
           
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
    
    func getInnerHTml() {
        self.webview.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value: Any!, error: Error!) -> Void in
            if error != nil {
                //Error logic
                return
            }

            let result = value as? String
            print(result)
            if result?.contains("successfully paid") == true{
                if self.isTopUp{
                    _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:"We have received the money it will take some time to reflect the money in your wallet." , cancelButtonTitle: "Great", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }else{
                    _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:"Thanks to complete payment process successfully!, Booking payment status will be updated in few minutes." , cancelButtonTitle: "Great", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        })
    }
}
