//
//  MessageCell.swift
//  MobiDoctor
//
//  Created by Ankit Kumar on 08/03/18.
//  Copyright © 2018 Sunfoucus Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import Localize_Swift

class MessageCell: UITableViewCell {
    
    //Properties
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var lblTime: UILabel!
     @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblUnreadMessageCount: UILabel!
    @IBOutlet var btnAudio: UIButton!
    @IBOutlet var btnArrow: UIButton!
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnBtnTwo: UIButton!
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgIconSenderSide: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        if imgProfile != nil {
           // self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
           // self.imgProfile.clipsToBounds = true
        }
        
        if lblUnreadMessageCount != nil {
            self.lblUnreadMessageCount.layer.cornerRadius = self.lblUnreadMessageCount.frame.size.height/2
            self.lblUnreadMessageCount.clipsToBounds = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
