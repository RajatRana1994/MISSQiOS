//
//  PaymentCardCell.swift
//  ValetIT
//
//  Created by ChandraPrakash on 11/05/21.
//

import UIKit

class PaymentCardCell: UITableViewCell {
    
    //MARK:- Properties
    @IBOutlet weak var lblCardNumber : UILabel!
    @IBOutlet weak var btnEditDel : UIButton!
    @IBOutlet weak var btnCheckPayment : UIButton!
    @IBOutlet weak var imgCardBrand : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
