//
//  CustomerSignUpVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 02/04/22.
//

import UIKit
import Localize_Swift
import GooglePlaces
class CustomerSignUpVC: UIViewController {
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var tfFullname:UITextField!
    @IBOutlet weak var tfAddress:UITextField!
    @IBOutlet weak var tfPhonenumber:UITextField!
    @IBOutlet weak var tfEmail:UITextField!
    @IBOutlet weak var tfPassword:UITextField!
    @IBOutlet weak var tfConfirmPassword:UITextField!
    @IBOutlet weak var tfCity:UITextField!
    @IBOutlet weak var tfState:UITextField!
    @IBOutlet weak var tfPostalCode:UITextField!
    @IBOutlet weak var vweCity:UIView!
    @IBOutlet weak var vweState:UIView!
    @IBOutlet weak var vwePostalCode:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    var selectedImage : UIImage?
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var lattitude: String = ""
    var longitude: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tfAddress.delegate = self
        tfPhonenumber.delegate = self
        self.vweCity.isHidden = true
        self.vweState.isHidden = true
        self.vwePostalCode.isHidden = true
        self.lblTitle.text = "Select Image"
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSelectImageAction(sender:UIButton){
        ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
            self.selectedImage = img
            self.imgProfile.image = img
        }
    }
    
    @IBAction func btnSignUpAction(sender: UIButton){
        if selectedImage == nil{
            AlertToastManager.shared.addToast(self.view, message: "please_select_image".localized(), position: .top)
        }else if (tfFullname.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_full_name".localized(), position: .top)
               }else if (tfAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                   AlertToastManager.shared.addToast(self.view, message: "please_select_address".localized(), position: .top)
                      }else if (tfPhonenumber.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                          AlertToastManager.shared.addToast(self.view, message: "please_enter_phone_number".localized(), position: .top)
                             }else if (tfEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                                 AlertToastManager.shared.addToast(self.view, message: "please_enter_email_address".localized(), position: .top)
               }else if AppManager.isValidEmail(self.tfEmail.text!) == false{
                   AlertToastManager.shared.addToast(self.view, message: "please_enter_valid_email_address".localized(), position: .top)
               }else if (tfPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
                   AlertToastManager.shared.addToast(self.view, message: "please_enter_password".localized(), position: .top)
        }else if tfPassword.text?.count ?? 0 < 8 {
            AlertToastManager.shared.addToast(self.view, message: "password_should_be_of_8_digits".localized(), position: .top)
        }else if (tfConfirmPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_confirm_password".localized(), position: .top)
        }else if tfPassword.text != tfConfirmPassword.text{
            AlertToastManager.shared.addToast(self.view, message: "password_dosen't_match".localized(), position: .top)
        }else if (tfCity.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_city".localized(), position: .top)
        }else if (tfState.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_state".localized(), position: .top)
        }else if (tfPostalCode.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_postal_code".localized(), position: .top)
        }
        else{
            self.apiRegisterUser()
        }
       
    }
    func apiRegisterUser()  {
        
        var deviceToken:String = ""
        if let deviceTokenVal = UserDefaults.standard.object(forKey: "DeviceToken") as? String{
            deviceToken = deviceTokenVal
        }
        var parameter = Dictionary<String, String>()
        parameter["email"] =  self.tfEmail.text ?? ""
        parameter["name"] =  self.tfFullname.text ?? ""
        parameter["password"] = self.tfPassword.text ?? ""
        parameter["userType"] = "0"
        parameter["phone"] =   "\(self.tfPhonenumber.text!)"
        parameter["address"] =  self.tfAddress.text ?? ""
        parameter["latitude"] =  self.lattitude
        parameter["longitude"] = self.longitude
        parameter["deviceType"] = "2"
        parameter["deviceToken"] = deviceToken
      //  parameter["dob"] = tfBench.text ?? ""
      //  parameter["serviceIds"] = tfDeadlift.text ?? ""
        parameter["city"] =  self.tfCity.text ?? ""
        parameter["state"] = self.tfState.text ?? ""
        parameter["postCode"] = self.tfPostalCode.text ?? ""
        

        var temp = [MultipartData]()
        temp.append(MultipartData.init(medaiObject: self.selectedImage, mediaKey: "profile"))
        ServerManager.shared.showHud()
        
        
        print(parameter)
        ServerManager.shared.httpUploadWithHeader(api: API_BASE_URL + "user/signup",method: .post, params: parameter, multipartObject: temp, successHandler: { (JSON) in
            ServerManager.shared.hidHud()
            if JSON["status"].intValue == 200{
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:JSON["message"].stringValue , cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    let data = JSON["data"]
                    UserDefaults.SFSDefault(setValue: data["authorizationKey"].stringValue, forKey: kAuthToken)
                    UserDefaults.SFSDefault(setValue: data["id"].stringValue , forKey: kUserID)
                    UserDefaults.standard.set(true, forKey: kIsLogin)
                    let currentUser = User.init(userData: data)
                    AppManager.saveLoggedInUser(currentUser: currentUser)
                    AppManager.getLoggedInUser()
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetTabbarController()
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
extension CustomerSignUpVC: UITextFieldDelegate{
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
extension CustomerSignUpVC: GMSAutocompleteViewControllerDelegate {

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
                                 self.tfCity.text = self.city
                                 case "political":
                                 self.state = addressComponent.name
                                 self.tfState.text = self.state
                                  case "postal_code":
                                 self.postalCode = addressComponent.name
                                 self.tfPostalCode.text = self.postalCode
                             default:
                                 break
                             }
                         }
                     }
                      self.vweCity.isHidden = true
                      self.vweState.isHidden = true
                      self.vwePostalCode.isHidden = true
                      if self.city == "" {
                          self.vweCity.isHidden = false
                      }
                      if self.state == "" {
                          self.vweState.isHidden = false
                      }
                      if self.tfPostalCode.text == "" {
                          self.vwePostalCode.isHidden = false
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
