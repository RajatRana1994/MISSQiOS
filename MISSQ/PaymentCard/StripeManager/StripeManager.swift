//
//  StripeManager.swift
//  ValetIT
//
//  Created by iOS on 13/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class StripeManager: NSObject{
    typealias ServerSuccessCallBack = (_ json:JSON)->Void
    typealias ServerFailureCallBack=(_ error:Error?)->Void
    
    
    //MARK:- Create Customer Api
    func apiCreateCustomer(param:[String: Any],successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        Alamofire.request(GAPIConstant.createStripeCustomer(), method: .post, parameters: param, headers: headers)
            .validate().responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    print("Error : \(response.result.error!)")
                    break
                }
                
        }
    }
    
    //MARK:- Customer Add Card Api
    func apiCreateCard(param:[String: Any], view: UIView, sender : UIButton,successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        Alamofire.request(GAPIConstant.createStripeCard(customerId: loggedInUser.stripe_customer_id), method: .post, parameters: param, headers: headers)
            .validate().responseJSON { (response) in
                ServerManager.shared.hidHud()
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(let _):
                    sender.isUserInteractionEnabled = true
                    _ = UIAlertController.showAlertInViewController(viewController: (UIApplication.shared.windows.first?.rootViewController)!, withTitle:"Error" , message:"Invalid card data." , cancelButtonTitle: "Ok".localized(), destructiveButtonTitle: nil, otherButtonTitles: nil, tapBlock: { (c, a, i) in
                    })
                    break
                }
        }
    }
    //MARK:- create payment method
       func apiCreatePaymentMethod(param:[String: Any], view: UIView,successHandler:ServerSuccessCallBack?){
           let headers = [
               "Content-Type": "application/x-www-form-urlencoded",
               "Authorization": "Bearer " + StripeKeys.SECRET_KEY
           ]
           ServerManager.shared.showHud(showInView: view, label: "")
           Alamofire.request(GAPIConstant.createPaymentMethod(), method: .post, parameters: param, headers: headers)
               .validate().responseJSON { (response) in
                   ServerManager.shared.hidHud()
                switch(response.result) {
                   case .success(_):
                       if response.result.value != nil{
                           print("response\(response)")
                           let json = try! JSON(data: response.data!)
                           if (successHandler != nil){
                               if ((json.null) == nil){
                                   successHandler!(json)
                               }
                           }
                       }
                       break
                   case .failure(_):
                       print("Error : \(response.result.error!)")
                       break
                   }
           }
       }
    //MARK:- Get all cards Api
    func apiGetAllCards(param:[String: Any], view: UIView,successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        ServerManager.shared.showHud(showInView: view, label: "")
        Alamofire.request(GAPIConstant.getAllCards(customerId: loggedInUser.stripe_customer_id), method: .get, parameters: param, headers: headers)
            .validate().responseJSON { (response) in
                ServerManager.shared.hidHud()
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    print("Error : \(response.result.error!)")
                    break
                }
        }
    }
    
    //MARK:- delete Card
    
    func apiDeleteCard(cardId:String,successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        Alamofire.request(GAPIConstant.deleteCard(customerId: loggedInUser.stripe_customer_id, cardId: cardId), method: .delete, parameters: [:], headers: headers)
            .validate().responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    print("Error : \(response.result.error!)")
                    break
                }
        }
    }
    
    //MARK:- Get Csutomer Indo
    func apiGetCustomerInfo(successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        Alamofire.request(GAPIConstant.getCustomerInfo(customerId: loggedInUser.stripe_customer_id), method: .get, parameters: [:], headers: headers)
            .validate().responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    print("Error : \(response.result.error!)")
                    break
                }
        }
    }
    
    //MARK:- apiUpdateCustomer
    func apiUpdateCustomerInfo(param:[String: Any], successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        Alamofire.request(GAPIConstant.updateCustomerInfo(customerId: loggedInUser.stripe_customer_id), method: .post, parameters: param, headers: headers)
            .validate().responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    print("Error : \(response.result.error!)")
                    break
                }
        }
    }
    
    //MARK:- apiUpdateCustomer
    func apiChargeAmount(param:[String: Any], successHandler:ServerSuccessCallBack?){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer " + StripeKeys.SECRET_KEY
        ]
        Alamofire.request(GAPIConstant.apiChargeAccount(), method: .post, parameters: param,encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            if ((json.null) == nil){
                                successHandler!(json)
                            }
                        }
                    }
                    break
                case .failure(_):
                    ServerManager.shared.hidHud()
                    print("Error : \(response.result.error!)")
                    break
                }
        }
    }
}
