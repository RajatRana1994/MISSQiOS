//
//  EmployeeSignUpVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 02/04/22.
//

import UIKit
import Localize_Swift
import GooglePlaces
import DateToolsSwift
import SwiftUI
class EmployeeSignUpVC: UIViewController {
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var tfFullname:UITextField!
    @IBOutlet weak var tfAddress:UITextField!
    @IBOutlet weak var tfPhonenumber:UITextField!
    @IBOutlet weak var tfEmail:UITextField!
    @IBOutlet weak var tfDob:UITextField!
    @IBOutlet weak var imgPicture:UITextField!
    @IBOutlet weak var imgNBI:UITextField!
    @IBOutlet weak var imgPrimaryID:UITextField!
    @IBOutlet weak var tfPassword:UITextField!
    @IBOutlet weak var tfConfirmPassword:UITextField!
    @IBOutlet weak var btnTerms:UIButton!
    @IBOutlet weak var btnChildTutor:UIButton!
    @IBOutlet weak var btnHouseKeeping:UIButton!
    @IBOutlet weak var btnNanny:UIButton!
    @IBOutlet weak var btnMassage:UIButton!
    @IBOutlet weak var btnHaircut:UIButton!
    @IBOutlet weak var imgChildTutor:UIImageView!
    @IBOutlet weak var imgHouseKeeping:UIImageView!
    @IBOutlet weak var imgNanny:UIImageView!
    @IBOutlet weak var imgMassage:UIImageView!
    @IBOutlet weak var imgHaircut:UIImageView!
    @IBOutlet weak var tfCity:UITextField!
    @IBOutlet weak var tfState:UITextField!
    @IBOutlet weak var tfPostalCode:UITextField!
    @IBOutlet weak var vweCity:UIView!
    @IBOutlet weak var vweState:UIView!
    @IBOutlet weak var vwePostalCode:UIView!
    var imageSelfie : UIImage?
    var imageNBI : UIImage?
    var imagePrimary : UIImage?
    var serviceID: String = ""
    var selectedProfileImage : UIImage?
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var lattitude: String = ""
    var longitude: String = ""
    var dobAge: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgChildTutor.backgroundColor = UIColor.clear
        self.imgHouseKeeping.backgroundColor = UIColor.clear
        self.imgNanny.backgroundColor = UIColor.clear
        self.imgMassage.backgroundColor = UIColor.clear
        self.imgHaircut.backgroundColor = UIColor.clear
        
        self.imgChildTutor.image = UIImage(named: "ic_unchecker")
        self.imgHouseKeeping.image = UIImage(named: "ic_unchecker")
        self.imgNanny.image = UIImage(named: "ic_unchecker")
        self.imgMassage.image = UIImage(named: "ic_unchecker")
        self.imgHaircut.image = UIImage(named: "ic_unchecker")
        imgPicture.delegate = self
        imgNBI.delegate = self
        imgPrimaryID.delegate = self
        tfAddress.delegate = self
        self.setDatePicker()
        self.vweCity.isHidden = true
        self.vweState.isHidden = true
        self.vwePostalCode.isHidden = true
    }
    func setDatePicker(){
        let picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.maximumDate = Date()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        tfDob.inputView = picker
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dt = DateFormatter()
        dt.dateFormat = "dd/MM/yyyy"
        self.tfDob.text = dt.string(from: sender.date)
        self.dobAge = "\(Int(sender.date.timeIntervalSince1970))"
    }
    @IBAction func btnSelectImageAction(sender:UIButton){
        ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
            self.selectedProfileImage = img
            self.imgProfile.image = img
        }
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignUpAction(sender: UIButton){
        if (tfFullname.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_full_name".localized(), position: .top)
        }else if (tfAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_select_address".localized(), position: .top)
        }else if (tfPhonenumber.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_phone_number".localized(), position: .top)
        }else if (tfEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_enter_email_address".localized(), position: .top)
        }else if AppManager.isValidEmail(self.tfEmail.text!) == false{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_valid_email_address".localized(), position: .top)
        }else if (tfDob.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_select_date_of_birth".localized(), position: .top)
        }else if (imgPicture.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_select_selfie_picture".localized(), position: .top)
        }else if (imgNBI.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_select_nbi_picture".localized(), position: .top)
        }else if (imgPicture.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "please_select_primary_ID_picture".localized(), position: .top)
        }else if (tfPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_password".localized(), position: .top)
        }else if tfPassword.text?.count ?? 0 < 8 {
            AlertToastManager.shared.addToast(self.view, message: "password_should_be_of_8_digits".localized(), position: .top)
        }else if (tfConfirmPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            AlertToastManager.shared.addToast(self.view, message: "please_enter_confirm_password".localized(), position: .top)
        }else if tfPassword.text != tfConfirmPassword.text{
            AlertToastManager.shared.addToast(self.view, message: "password_dosen't_match".localized(), position: .top)
        }else if serviceID == ""{
            AlertToastManager.shared.addToast(self.view, message: "please_select_service".localized(), position: .top)
        }else if btnTerms.isSelected == false{
            AlertToastManager.shared.addToast(self.view, message: "terms".localized(), position: .top)
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
        parameter["userType"] = "1"
        parameter["phone"] =   "\(self.tfPhonenumber.text!)"
        parameter["address"] =  self.tfAddress.text ?? ""
        parameter["latitude"] =  self.lattitude
        parameter["longitude"] = self.longitude
        parameter["deviceType"] = "2"
        parameter["deviceToken"] = deviceToken
        parameter["dob"] = self.dobAge
        parameter["serviceIds"] = self.serviceID
        parameter["city"] =  self.tfCity.text ?? ""
        parameter["state"] = self.tfState.text ?? ""
        parameter["postCode"] = self.tfPostalCode.text ?? ""
        
        
        var temp = [MultipartData]()
        temp.append(MultipartData.init(medaiObject: self.imageSelfie, mediaKey: "profile"))
        temp.append(MultipartData.init(medaiObject: self.imageNBI, mediaKey: "nbi"))
        temp.append(MultipartData.init(medaiObject: self.imagePrimary, mediaKey: "primaryId"))
        ServerManager.shared.showHud()
        
        
        print(parameter)
        ServerManager.shared.httpUploadWithHeader(api: API_BASE_URL + "user/signup",method: .post, params: parameter, multipartObject: temp, successHandler: { (JSON) in
            ServerManager.shared.hidHud()
            if JSON["status"].intValue == 200{
                _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:"Your account is registered successfully. Please check your email to verify the account. " , cancelButtonTitle: "Ok", destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    self.navigationController?.popViewController(animated: true)
                    //                    let data = JSON["data"]
//                    UserDefaults.SFSDefault(setValue: data["authorizationKey"].stringValue, forKey: kAuthToken)
//                    UserDefaults.SFSDefault(setValue: data["id"].stringValue , forKey: kUserID)
//                    UserDefaults.standard.set(true, forKey: kIsLogin)
//                    let currentUser = User.init(userData: data)
//                    AppManager.saveLoggedInUser(currentUser: currentUser)
//                    AppManager.getLoggedInUser()
//                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                    windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetEmployeeTabbarController()
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
    
    @IBAction func btnTermsSelection(sender: UIButton){
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    @IBAction func btnTermsOpen(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "TermsConditionVC")as! TermsConditionVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnServiceAction(sender: UIButton){
        self.imgChildTutor.backgroundColor = UIColor.clear
        self.imgHouseKeeping.backgroundColor = UIColor.clear
        self.imgNanny.backgroundColor = UIColor.clear
        self.imgMassage.backgroundColor = UIColor.clear
        self.imgHaircut.backgroundColor = UIColor.clear
        
        self.imgChildTutor.image = UIImage(named: "ic_unchecker")
        self.imgHouseKeeping.image = UIImage(named: "ic_unchecker")
        self.imgNanny.image = UIImage(named: "ic_unchecker")
        self.imgMassage.image = UIImage(named: "ic_unchecker")
        self.imgHaircut.image = UIImage(named: "ic_unchecker")
        self.serviceID = "\(sender.tag)"
        if sender == btnChildTutor{
            self.imgChildTutor.image = UIImage(named: "ic_checker")
        }else if sender == btnHouseKeeping{
            self.imgHouseKeeping.image = UIImage(named: "ic_checker")
        }else if sender == btnNanny{
            self.imgNanny.image = UIImage(named: "ic_checker")
        }else if sender == btnMassage{
            self.imgMassage.image = UIImage(named: "ic_checker")
        }else if sender == btnHaircut{
            self.imgHaircut.image = UIImage(named: "ic_checker")
        }
    }
}
extension EmployeeSignUpVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfAddress{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
            return false
        }else if textField == self.imgPicture{
            ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
                self.imageSelfie = img
                self.imgPicture.text = "\(Int(Date().timeIntervalSince1970)).png"
            }
            return false
        }else  if textField == self.imgNBI{
            ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
                self.imageNBI = img
                self.imgNBI.text = "\(Int(Date().timeIntervalSince1970)).png"
            }
            return false
        }else  if textField == self.imgPrimaryID{
            ImagePickerManager.shared.callPickerOptions(self.view) { (img, data) in
                self.imagePrimary = img
                self.imgPrimaryID.text = "\(Int(Date().timeIntervalSince1970)).png"
            }
            return false
        }
        return true
    }
}
extension EmployeeSignUpVC: GMSAutocompleteViewControllerDelegate {
    
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
