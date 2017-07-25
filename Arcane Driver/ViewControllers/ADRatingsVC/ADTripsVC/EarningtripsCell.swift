//
//  EarningtripsCell.swift
//  SIX Driver
//
//  Created by apple on 26/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class EarningtripsCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
