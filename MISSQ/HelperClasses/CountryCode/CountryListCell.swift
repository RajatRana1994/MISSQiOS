//
//  CountryListCell.swift
//  JobPortal
//
//  Created by sfs17 on 4/27/17.
//  Copyright © 2017 Apple02Sunfocus. All rights reserved.
//

import UIKit

class CountryListCell: UITableViewCell {

    @IBOutlet weak var lblDialingCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var imgCountry: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
