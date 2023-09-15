//
//  CommonModel.swift
//  Central Driver
//
//  Created by MAC 3 on 07/09/18.
//  Copyright © 2018 MAC 3. All rights reserved.
//

import UIKit
import SwiftyJSON


class postsData: NSObject {
    var id = Int()
    var user_id = Int()
    var descriptionn = String()
    var post_type = Int()
    var tag_ids = String()
    var default_url = String()
    var status = Int()
    var location = String()
    var latitude = Double()
    var longitude = Double()
    var thumb_image = String()
    var created = Double()
    var you_like = Int()
    var total_like = Int()
    var total_comment = Int()
    var user = UserInfo()
   
    override init() {
        
    }
    init(data:JSON) {
        self.id                 = data["id"].intValue
        self.user_id                 = data["user_id"].intValue
        self.descriptionn                 = data["description"].stringValue
        self.post_type                 = data["post_type"].intValue
        self.tag_ids                 = data["tag_ids"].stringValue
        self.default_url                 = data["default_url"].stringValue
        self.status                 = data["status"].intValue
        self.location                 = data["location"].stringValue
        self.latitude                 = data["latitude"].doubleValue
        self.longitude                 = data["longitude"].doubleValue
        self.thumb_image                 = data["thumb_image"].stringValue
        self.created                 = data["created"].doubleValue
        self.you_like                 = data["you_like"].intValue
        self.total_like                 = data["total_like"].intValue
        self.total_comment                 = data["total_comment"].intValue
       let userInfo = data["user_info"]
        self.user = UserInfo.init(data: userInfo)
    }
}
class UserInfo: NSObject {
    
    var id = Int()
    var name = String()
    var username = String()
    var email = String()
    var profile = String()
    var dob = String()
    var gender = String()
    var phone = String()
    
    override init() {
        
    }
    init(data:JSON) {
        self.id                 = data["id"].intValue
        self.name                 = data["name"].stringValue
        self.username                 = data["username"].stringValue
        self.email                 = data["email"].stringValue
        self.profile                 = data["profile"].stringValue
        self.dob                 = data["dob"].stringValue
        self.gender                 = data["gender"].stringValue
        self.phone                 = data["phone"].stringValue
       
        
    }
}
