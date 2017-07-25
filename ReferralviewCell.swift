//
//  ReferralviewCell.swift
//  SIX Driver
//
//  Created by Apple on 25/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ReferralviewCell: UITableViewCell {

    @IBOutlet var REferraluserimage: UIImageView!
    
    @IBOutlet var Userfirstname: UILabel!
    
    @IBOutlet var Userlastname: UILabel!
    
    @IBOutlet var usertype: UILabel!
    @IBOutlet var usercategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        REferraluserimage.layer.cornerRadius = REferraluserimage.frame.size.width / 2
        REferraluserimage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
