//
//  OfferDetailsCell.swift
//  TendorApp
//
//  Created by Samir Samanta on 21/02/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class OfferDetailsCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValues: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
