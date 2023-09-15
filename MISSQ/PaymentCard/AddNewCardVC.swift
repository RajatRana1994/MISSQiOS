//
//  AddNewCardVC.swift
//  ValetIT
//
//  Created by iOS on 01/04/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import Stripe

class AddNewCardVC: UIViewController, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    @IBOutlet weak var btnSaveCard: UIButton!
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    
    //MARK:- Variable
    let datepicker = UIDatePicker()
    var isEdit = false
     var params = Dictionary<String, Any>()
    var stripeManager = StripeManager()
    typealias isCardAdded = (_ isSucess : Bool) -> Void
    typealias isPaymentSucceed = (_ json : String) -> Void
    var isCardAddedDelegate : isCardAdded?
    var isPaymentSucceedDelegate : isPaymentSucceed?
    var amount: String = ""
    var clientSecret: String = ""
    var entryPoint: String = ""
    var customerStripeID : String = ""
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        tfCvvNumber.delegate = self
//        tfCardName.setLeftPaddingView()
//        tfExpiryDate.setLeftPaddingView()
//        tfCvvNumber.setLeftPaddingView()
 //       datePicker()
//        tfCardNumber?.setup()
//        tfCardNumber.placeholder = "XXXX XXXX XXXX XXXX"
//        tfExpiryDate.placeholder = "MM YYYY"
        self.title = "add_new_card".localized()
     //   if loggedInUser.stripeId == "" || loggedInUser.stripeId == " "{
            var params = Dictionary<String, Any>()
            params["description"] = "created customer for \(AppManager.getUserID())"
            self.stripeManager.apiCreateCustomer(param: params){ (response) in
                print(response)
                let stripeCustomerId = response["id"].stringValue
                self.customerStripeID = stripeCustomerId
                let user = loggedInUser
                user?.stripe_customer_id = stripeCustomerId
                AppManager.saveLoggedInUser(currentUser: user!)
                AppManager.getLoggedInUser()
                self.updateCustomerProfile(stripeCustomerId: stripeCustomerId)
            }
     //   }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    //MARK:- Button Clicked Actions
    @IBAction func btnBackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveCardAction(sender:UIButton){
        if self.cardTextField.isValid == false{
            AlertToastManager.shared.addToast(self.view, message: "Please add card details".localized(), position: .top)
            return
        }
        self.addCard()
        
    }
    //MARK:- Button save for future use Actions
    @IBAction func btnSaveForFutureUseAction(sender:UIButton){
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
//    func createPaymentMethodOnStripe() {
//        let expiryDate = self.tfExpiryDate.text?.components(separatedBy: " ")
//        var parameter = Dictionary<String, Any>()
//        parameter["type"] = "card"
//        parameter["card[number]"] = self.tfCardNumber.text ?? ""
//        parameter["card[exp_month]"] = expiryDate?.first ?? ""
//        parameter["card[exp_year]"] = expiryDate?.last ?? ""
//        parameter["card[cvc]"] = self.tfCvvNumber.text ?? ""
//        stripeManager.apiCreatePaymentMethod(param: parameter, view: self.view) { (json) in
//            let id = json["id"].stringValue
//            //self.params["paymentMethodId"] = id
//            self.confirmPaymentOnStripe(paymentMethodID: id)
//        }
//    }
    
    func confirmPaymentOnStripe(paymentMethodID: String) {
        let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: self.clientSecret)
                setupIntentParams.paymentMethodID = paymentMethodID

                let paymentHandler = STPPaymentHandler.shared()
                paymentHandler.confirmSetupIntent(
                    setupIntentParams,
                    with: self,
                    completion: { status, intent, error in
                        DispatchQueue.main.async {
                            if case .succeeded = status, let intent = intent {
                                //Sucesss
                                print(intent)
                            } else {
                                //Error
                                print(error)
                            }
                        }
                })
    }
//    func validateContent() -> Bool {
//        if self.tfCardName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//           // AlertToastManager.shared.addToast(self.view, message: "", position: .top)
//            AlertToastManager.shared.addToast(self.view, message: "enter_card_holder_name".localized(), position: .top)
//            return false
//        }else if tfCardNumber.text?.isEmpty == true {
//            AlertToastManager.shared.addToast(self.view, message: "enter_card_number".localized(), position: .top)
//            return false
//        }else if self.tfExpiryDate.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//            AlertToastManager.shared.addToast(self.view, message: "enter_expiry_date".localized(), position: .top)
//            return false
//        }else if self.tfCvvNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//            AlertToastManager.shared.addToast(self.view, message: "enter_cvv_number".localized(), position: .top)
//            return false
//        }else if tfCvvNumber.text?.count ?? 0 < 3 {
//            AlertToastManager.shared.addToast(self.view, message: "enter_valid_cvv_number".localized(), position: .top)
//            return false
//        }else{
//            return true
//        }
//        return false
//    }
//
    
    //MARk:- For Card Number
    private func performCardNumberFormatterTest() {
       let cardNumberFormatter = DECardNumberFormatter()
       
       // AmEx
       print(cardNumberFormatter.number(from: "34 12 123456 12345"))
       print(cardNumberFormatter.number(from: "37 12 123456 12345"))
       
       // Diners Club
       var cardNumber = "300 1 123456 1234"
       print(cardNumberFormatter.number(from: cardNumber))
       if cardNumberFormatter.isValidLuhnCardNumber(cardNumber) {
          print("Card number: \(cardNumber) - is valid!")
       }
       
       // UATP
       cardNumber = "1 234 12345 123456 1234"
       print(cardNumberFormatter.number(from: cardNumber))
       if cardNumberFormatter.isValidLuhnCardNumber(cardNumber) {
          print("Card number: \(cardNumber) - is valid!")
       }
       
       // Visa
       cardNumber = "4111111111111111"
       print(cardNumberFormatter.number(from: cardNumber))
       if cardNumberFormatter.isValidLuhnCardNumber(cardNumber) {
          print("Card number: \(cardNumber) - is valid!")
       }
    }
    
    //MARK:- Add card
    func addCard(){
       
        if self.clientSecret != ""{
            // topUp
            self.startCheckout()
        }else{
        let cardParams = STPCardParams()
            cardParams.number = self.cardTextField.cardNumber
            cardParams.expMonth = UInt(self.cardTextField.expirationMonth)
            cardParams.expYear = UInt(self.cardTextField.expirationYear)
        cardParams.cvc = self.cardTextField.cvc
        ServerManager.shared.showHud(showInView: view, label: "")
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                ServerManager.shared.hidHud()
                AlertToastManager.shared.addToast(self.view, message: error?.localizedDescription ?? "", position: .top)
                return
            }
            print(token.tokenId)
                var params = Dictionary<String, Any>()
                params["source"] = token.tokenId
                self.stripeManager.apiCreateCard(param: params, view: self.view, sender: self.btnSaveCard){ (response) in
                    print(response)
                    self.btnSaveCard.isUserInteractionEnabled = true
                    let cardID = response["id"].stringValue
                    _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:"card_added_sucessfully".localized() , cancelButtonTitle: "Ok".localized(), destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }
            }
            
        }
    
    }
    func startCheckout() {
       
        ServerManager.shared.showHud()
                let paymentIntentClientSecret = self.clientSecret
                let cardParams = self.cardTextField.cardParams
                let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
                paymentIntentParams.paymentMethodParams = paymentMethodParams
                
                // Submit the payment
                let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            ServerManager.shared.hidHud()
                    switch (status) {
                    case .failed:
                        print("Payment failed")
                        print(error)
                       
                        break
                    case .canceled:
                        print("Payment canceled")
                       
                        break
                    case .succeeded:
                        print("Payment succeeded")
                        _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message:"Payment succeeded" , cancelButtonTitle: "Ok".localized(), destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                            if self.isPaymentSucceedDelegate != nil{
                                self.isPaymentSucceedDelegate!(paymentIntent? .description ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                        break
                    @unknown default:
                        fatalError()
                        break
                    }

    }
    }
//    func datePicker() {
//        tfExpiryDate.inputView = datepicker
//        if #available(iOS 13.4, *) {
//            datepicker.preferredDatePickerStyle = .wheels
//        } else {
//            // Fallback on earlier versions
//        }
//        datepicker.addTarget(self, action: #selector(donePressed), for: .valueChanged)
//        datepicker.minimumDate = Date()
//        datepicker.datePickerMode = .date
//    }
//
//    @objc func donePressed(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM yyyy"
//        tfExpiryDate.text = formatter.string(from: datepicker.date)
//    }
    /*
     else if textField == self.tfExpiryDate{
         maxLength = 5
         if self.tfExpiryDate.text?.count == 2{
             //Handle backspace being pressed
             if !(string == "") {
                 // append the text
                 self.tfExpiryDate.text = self.tfExpiryDate.text! + "/"
             }
         }
         // check the condition not exceed 9 chars
         return !(textField.text!.count > 4 && (string.count ) > range.length)
     }
     */
}

extension AddNewCardVC{
    //MARK:- updateProfile()
    func updateCustomerProfile(stripeCustomerId: String){
  /*  var parameter = Dictionary<String, String>()
        parameter["stripe_customer_id"] = stripeCustomerId
        parameter["full_name"] = loggedInUser.username
        ServerManager.shared.showHud()
        ServerManager.shared.startService(with: .POST, path: GAPIConstant.updateProfile(), parameters: parameter, files: []){ (response) in
            DispatchQueue.main.async {
                ServerManager.shared.hideHud()
                switch(response) {
                case .Success(let result) :
                    if let data = result as? JSON {
                        if data["status"].intValue == 200{
                            let user = Constants.loggedInUser
                            user?.stripe_customer_id = stripeCustomerId
                            AppManager.saveLoggedInUser(currentUser: user!)
                            AppManager.getLoggedInUser()
                        }
                        else{
                            AlertManager.shared.show(GPAlert(title: Constants.appName, message: data["message"].stringValue), vc: self)
                        }
                    }
                    break
                case .Failure(let message):
                    UIAlertController.showAlert(withTitle: "Error", message: message)
                }
            }
        }
   */
    }
   
}

//extension AddNewCardVC : UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if range.location == 0 && (string == " ") {
//            return false
//        }
//        var maxLength = Int()
//        if textField == self.tfCardName{
//            maxLength = 100
//        }else if textField == self.tfCardNumber{
//            maxLength = 16
//        }else if textField == self.tfCvvNumber{
//            maxLength = 3
//        }
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
//}
