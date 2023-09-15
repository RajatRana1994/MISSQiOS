//
//  CustomCell.swift
//  UICollectionViewInUIView
//
//  Created by michal on 31/05/2019.
//  Copyright © 2019 borama. All rights reserved.
//

import UIKit
import Localize_Swift

class CustomCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnDetail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
