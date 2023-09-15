//
//  Message.swift
//  SocketDemo
//
//  Created by Ankit Kumar on 17/09/18.
//  Copyright © 2018 Sunfoucus Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON


class Message: NSObject {
    //MARK: Proverties
    

    var message = String()
    var productID = String()
    var idd = String()
   var messageType = String()
    var opponentId = String()
    var opponentname = String()
    var createdAt = String()

    override init() {
        
    }
    
    //MARK: Parsing Methods
    //Parse all reveived message
    init(parser objJson: JSON ) {
        /*
         {
     bookingId = 1;
     created = 1638862798;
     friendInfo =             {
         email = "ram@ram.com";
         name = "ram vashisht";
         phone = 8894494942;
         profile = "";
     };
     id = 1;
     "is_read" = 0;
     message = "hello world";
     "message_type" = 0;
     modified = 1638862798;
     "receiver_id" = 4;
     "sender_id" = 5;
     "thread_id" = 1;
     videoLength = 0;
 }
);
         */
       
        self.message = objJson["message"].stringValue
        self.messageType = objJson["message_type"].stringValue
        self.idd = objJson["id"].stringValue
        self.opponentId = objJson["sender_id"].stringValue
        self.opponentname = objJson["friendInfo"]["name"].stringValue
        self.productID = objJson["bookingId"].stringValue
        let time = objJson["created"].doubleValue
        self.createdAt = AppManager.convertTimeStampToDate(timeStamp: time, dt: "EEE MMM dd")
    }
    
}






