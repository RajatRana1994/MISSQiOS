//
//  User.swift
//  MobiDoctor
//
//  Created by Ankit Kumar on 19/01/18.
//  Copyright © 2018 Sunfoucus Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
/*
 {
         "id": 8,
         
         "dob": 1078129103,
         "userType": 1,
         "balance": 1250,
         "address": "Roorkee, Uttarakhand, India",
         "stripe_connect": 1,
         "stripeId": "acct_1KaclZ4NDGC303V6",
         "primaryId": "http://54.169.185.218/uploads/1641197935275.jpg",
         "nbi": "http://54.169.185.218/uploads/1641197935275.jpg",
         "isOnDuty": 0,
         "lang": "en",
         "isDocumentVerify": 0,
         "services": [
             {
                 "id": 4,
                 "name": "House Keeping ",
                 "image": "http://54.169.185.218/uploads/1647428976038.jpeg",
                 "price": 1,
                 "status": 1,
                 "created": 0,
                 "modified": 1647428976
             }
         ],
         "ratingStars": {
             "rating1": 0,
             "rating2": 0,
             "rating3": 0,
             "rating4": 0,
             "rating5": 0
         },
         "rating": 0
     }
 }
 */
class User: NSObject ,NSCoding  {
 
    var username = String()
    var email = String()
    var image = String()
    
    var phone = String()
    
    
    var loginType = String()
    var dob = String()
    var balance = String()
    var address = String()
    var stripeConnect = String()
    var stripeId = String()
    var primaryId = String()
    var nbiImage = String()
    var isOnDuty = String()
    var lang = String()
    var serviceNAme = String()
    var isDocumentVerify = String()
    var stripe_customer_id = String()
    override init() {
        
    }
  
    init(userData:JSON) {
        
        self.username    = userData["name"].stringValue
        self.email     = userData["email"].stringValue
        self.image     = userData["profile"].stringValue
        
        self.phone     = userData["phone"].stringValue
        self.loginType     = userData["userType"].stringValue
        
        
        self.dob    = userData["dob"].stringValue
        self.balance    = userData["balance"].stringValue
        self.address    = userData["address"].stringValue
        self.stripeConnect    = userData["stripe_connect"].stringValue
        self.stripeId    = userData["stripeId"].stringValue
        self.primaryId    = userData["primaryId"].stringValue
        self.nbiImage    = userData["nbi"].stringValue
        self.isOnDuty    = userData["isOnDuty"].stringValue
        self.lang    = userData["lang"].stringValue
        let services = userData["services"].arrayValue
        if services.count > 0{
            self.serviceNAme    = services[0]["name"].stringValue
        }
        
        self.isDocumentVerify    = userData["isDocumentVerify"].stringValue
        self.stripe_customer_id    = userData["stripe_customer_id"].stringValue
        
}
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        
        self.username    = aDecoder.decodeObject(forKey: "username") as! String
        self.email     = aDecoder.decodeObject(forKey: "email") as! String
        self.image     = aDecoder.decodeObject(forKey: "image") as! String
        
        self.phone        = aDecoder.decodeObject(forKey: "phone") as! String
        self.loginType    = aDecoder.decodeObject(forKey: "loginType") as! String
        
        self.dob     = aDecoder.decodeObject(forKey: "dob") as! String
        self.balance     = aDecoder.decodeObject(forKey: "balance") as! String
        self.address     = aDecoder.decodeObject(forKey: "address") as! String
        
        self.stripeId     = aDecoder.decodeObject(forKey: "stripeId") as! String
        
        self.nbiImage     = aDecoder.decodeObject(forKey: "nbiImage") as! String
        self.isOnDuty     = aDecoder.decodeObject(forKey: "isOnDuty") as! String
        self.serviceNAme     = aDecoder.decodeObject(forKey: "serviceNAme") as! String
        self.lang     = aDecoder.decodeObject(forKey: "lang") as! String
        self.isDocumentVerify     = aDecoder.decodeObject(forKey: "isDocumentVerify") as! String
        self.stripeConnect     = aDecoder.decodeObject(forKey: "stripeConnect") as! String
        self.primaryId     = aDecoder.decodeObject(forKey: "primaryId") as! String
        self.stripe_customer_id     = aDecoder.decodeObject(forKey: "stripe_customer_id") as! String
      
      
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.username , forKey: "username")
        aCoder.encode(self.email , forKey: "email")
        aCoder.encode(self.image , forKey: "image")
        aCoder.encode(self.phone , forKey: "phone")
        aCoder.encode(self.loginType , forKey: "loginType")
        aCoder.encode(self.dob , forKey: "dob")
        aCoder.encode(self.balance , forKey: "balance")
        aCoder.encode(self.address , forKey: "address")
        aCoder.encode(self.isOnDuty , forKey: "isOnDuty")
        aCoder.encode(self.serviceNAme , forKey: "serviceNAme")
        aCoder.encode(self.lang , forKey: "lang")
        aCoder.encode(self.nbiImage , forKey: "nbiImage")
        aCoder.encode(self.isDocumentVerify , forKey: "isDocumentVerify")
        aCoder.encode(self.stripeId , forKey: "stripeId")
        aCoder.encode(self.primaryId , forKey: "primaryId")
        aCoder.encode(self.stripeConnect , forKey: "stripeConnect")
        aCoder.encode(self.stripe_customer_id , forKey: "stripe_customer_id")
       
        
      
        
}
}




class CardInfo: NSObject {
    var address_state = String()
    var dynamic_last4 = String()
    var address_zip = String()
    var id = String()
    var address_zip_check = String()
    var customer = String()
    var exp_year = String()
    var object = String()
    var exp_month = String()
    var last4 = String()
    var cvc_check = String()
    var address_city = String()
    var address_line1_check = String()
    var tokenization_method = String()
    var fingerprint = String()
    var address_country = String()
    var name = String()
    var brand = String()
    var address_line2 = String()
    var funding = String()
    var address_line1 = String()
    var country = String()
    
    override init() {
    }
    
    init(objData:JSON) {
        self.address_state = objData["address_state"].stringValue
        self.dynamic_last4 = objData["dynamic_last4"].stringValue
        self.address_zip = objData["address_zip"].stringValue
        self.id = objData["id"].stringValue
        self.address_zip_check = objData["address_zip_check"].stringValue
        self.customer = objData["customer"].stringValue
        self.exp_year = objData["exp_year"].stringValue
        self.object = objData["object"].stringValue
        self.exp_month = objData["exp_month"].stringValue
        self.last4 = objData["last4"].stringValue
        self.cvc_check = objData["cvc_check"].stringValue
        self.address_city = objData["address_city"].stringValue
        self.address_line1_check = objData["address_line1_check"].stringValue
        self.tokenization_method = objData["tokenization_method"].stringValue
        self.fingerprint = objData["fingerprint"].stringValue
        self.address_country = objData["address_country"].stringValue
        self.name = objData["name"].stringValue
        self.brand = objData["brand"].stringValue
        self.address_line2 = objData["address_line2"].stringValue
        self.funding = objData["funding"].stringValue
        self.address_line1 = objData["address_line1"].stringValue
        self.country = objData["country"].stringValue
    }
}
