//
//  CustomerProfileVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import Cosmos
import SwiftyJSON
import GooglePlaces
class CustomerProfileVC: UIViewController {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var avgRating:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var rateView:CosmosView!
    @IBOutlet weak var tfAddress:UITextField!
    @IBOutlet weak var tfName:UITextField!
    @IBOutlet weak var tfPhone:UITextField!
    @IBOutlet weak var tfPass:UITextField!
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var lattitude: String = ""
    var longitude: String = ""
    var dict = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()

        tfPass.isUserInteractionEnabled = false
        self.tfAddress.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.apiGetData()
    
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnChangePasswordAction(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "ChangePAsswordVC") as! ChangePAsswordVC
        vc.name = dict["name"].stringValue
        vc.email = dict["email"].stringValue
        vc.rating  = dict["rating"].doubleValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLogoutAction(){
        _ = UIAlertController.showAlertInViewController(viewController: self, withTitle: kAlertTitle, message: "are_you_sure_you_want_to_logout?".localized(), cancelButtonTitle: "cancel".localized(), destructiveButtonTitle: nil, otherButtonTitles: ["yes".localized()], tapBlock: { (a, b, i) in
            if i == 2{
                ServerManager.shared.httpPost(request: API_BASE_URL + "logout", params: [:]) { json in
                    UserDefaults.standard.set(false, forKey: kIsLogin)
                    let vc = AppDelegate.getViewController(identifire: "LoginVC")as! LoginVC
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } failureHandler: { error in
                    
                }
            }
        })
    }
    
    @IBAction func onClickDeleteAccount(_ sender: UIButton) {
        _ = UIAlertController.showAlertInViewController(viewController: self, withTitle: kAlertTitle, message: "Are you sure you want to delete account?", cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"], tapBlock: { (a, b, i) in
            if i == 2{
                ServerManager.shared.httpDelete(request: API_BASE_URL + "user-account-delete", params: [:]) { json in
                    UserDefaults.standard.set(false, forKey: kIsLogin)
                    let vc = AppDelegate.getViewController(identifire: "LoginVC")as! LoginVC
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } failureHandler: { error in
                    
                }
            }
        })
    }
    
func apiGetData() {
    ServerManager.shared.showHud()
    ServerManager.shared.httpGet(request:API_BASE_URL + "user/profile/\(AppManager.getUserID())") { (response) in
        ServerManager.shared.hidHud()
        AlertManager.shared.hideErrorView()
        if response["status"].intValue == 200 {
            let data = response["data"]
            self.dict = data
            self.imgProfile.sd_setImage(with: URL.init(string: data["profile"].string ?? ""), placeholderImage: UIImage(named: "app_logo"))
            self.lblName.text = data["name"].stringValue
            self.lblEmail.text = data["email"].stringValue
            self.tfAddress.text = data["address"].stringValue
            self.tfName.text = data["name"].stringValue
            self.tfPhone.text = data["phone"].stringValue
            self.rateView.rating = data["rating"].doubleValue
            self.avgRating.text = "\(data["rating"].stringValue)"
//                self.city = data["name"].stringValue
//                self.state = data["name"].stringValue
//                self.postalCode = data["name"].stringValue
//                self.lattitude = data["name"].stringValue
//                self.longitude = data["name"].stringValue
        }else{
            AlertToastManager.shared.addToast(self.view, message: response["message"].stringValue, position: .top)
            
        }
    } failureHandler: { (error) in
        ServerManager.shared.hidHud()
        AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
            self.apiGetData()
        })
    } progressHandler: { (progress) in
        
    }
}
@IBAction func btnSelectImageAction(sender:UIButton){
    ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
        self.imgProfile.image = img
    }
}

@IBAction func btnSignUpAction(sender: UIButton){
   if (tfName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
       AlertToastManager.shared.addToast(self.view, message: "please_enter_full_name".localized(), position: .top)
           }else if (tfAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
               AlertToastManager.shared.addToast(self.view, message: "please_select_address".localized(), position: .top)
                  }else if (tfPhone.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                      AlertToastManager.shared.addToast(self.view, message: "please_enter_phone_number".localized(), position: .top)
                         }else{
        self.apiRegisterUser()
    }
   
}
func apiRegisterUser()  {
    var parameter = Dictionary<String, String>()
    parameter["name"] =  self.tfName.text ?? ""
    parameter["userType"] = "0"
    parameter["phone"] =   "\(self.tfPhone.text!)"
    
    
    if self.longitude != ""{
        parameter["address"] =  self.tfAddress.text ?? ""
        parameter["latitude"] =  self.lattitude
        parameter["longitude"] = self.longitude
        parameter["city"] =  self.city
        parameter["state"] = self.state
        parameter["postCode"] = self.postalCode
    }
   

    var temp = [MultipartData]()
    temp.append(MultipartData.init(medaiObject: self.imgProfile.image, mediaKey: "profile"))
    ServerManager.shared.showHud()
    
    
    print(parameter)
    ServerManager.shared.httpUploadWithHeader(api: API_BASE_URL + "user/profile",method: .post, params: parameter, multipartObject: temp, successHandler: { (JSON) in
        ServerManager.shared.hidHud()
        if JSON["status"].intValue == 200{
            _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:JSON["message"].stringValue , cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                let data = JSON["data"]
                let currentUser = User.init(userData: data)
                AppManager.saveLoggedInUser(currentUser: currentUser)
                AppManager.getLoggedInUser()
            })
            
            
        }else{
            AlertToastManager.shared.addToast(self.view, message: JSON["error_message"].stringValue, position: .top)
        }
    }, failureHandler: { (error) in
        ServerManager.shared.hidHud()
        AppManager.showErrorDialog(viewControler: self, message: AppManager.getErrorMessage(error! as NSError))
    }) { (progress) in
        // self.UpdateProgressBar(progress: progress!)
    }
}
}
extension CustomerProfileVC: UITextFieldDelegate{
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == self.tfAddress{
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        return false
    }
    return true
}
}
extension CustomerProfileVC: GMSAutocompleteViewControllerDelegate {

// Handle the user's selection.
func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
  self.tfAddress.text = place.formattedAddress ?? ""
  self.lattitude = "\(place.coordinate.latitude )"
  self.longitude = "\(place.coordinate.longitude )"
  // Show AddressComponents
              if place.addressComponents != nil {
                  
                  for addressComponent in (place.addressComponents)! {
                     for type in (addressComponent.types){
print("\(type): \(addressComponent.name)")
                         switch(type){
                             case "locality":
                             self.city = addressComponent.name
                             case "political":
                             self.state = addressComponent.name
                              case "postal_code":
                             self.postalCode = addressComponent.name
                         default:
                             break
                         }
                     }
                 }
              }
dismiss(animated: true, completion: nil)
}

func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
// TODO: handle the error.
print("Error: ", error.localizedDescription)
}

// User canceled the operation.
func wasCancelled(_ viewController: GMSAutocompleteViewController) {
dismiss(animated: true, completion: nil)
}

}

