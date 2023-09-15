//
//  NewRequestPopUpVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 22/06/22.
//

import UIKit
import Localize_Swift
class NewRequestPopUpVC: UIViewController {
    typealias chooseAction = ( _ isdetail: Bool) -> Void
    var chooseActionCompilation : chooseAction?
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblCategory:UILabel!
    @IBOutlet weak var lblCategoryImage:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPrice.text = "\("price".localized()) ₱\(AppDelegate.sharedDelegate.price)"
        self.lblCategory.text = AppDelegate.sharedDelegate.serviceName
        self.lblCategoryImage.sd_setImage(with: URL(string: AppDelegate.sharedDelegate.serviceImage), placeholderImage: UIImage(named: "app_logo"))
    }
    @IBAction func btnBackAction(){
        self.dismiss(animated: true)
    }
    @IBAction func btnViewDetailAction(){
        if self.chooseActionCompilation != nil{
            self.chooseActionCompilation!(true)
            self.dismiss(animated: true)
        }
    }
    @IBAction func btnAcceptAction(){
        self.apiAcceptRejectOrder(type: "1", idd: AppDelegate.sharedDelegate.bookingID)
    }
    @IBAction func btnDeclineAction(){
        self.apiAcceptRejectOrder(type: "2", idd: AppDelegate.sharedDelegate.bookingID)
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
                 if self.chooseActionCompilation != nil{
                     self.chooseActionCompilation!(true)
                     self.dismiss(animated: false)
                 }
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
