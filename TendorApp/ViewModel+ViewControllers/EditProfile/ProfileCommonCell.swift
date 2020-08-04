//
//  ProfileCommonCell.swift
//  TendorApp
//
//  Created by Samir Samanta on 29/01/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class ProfileCommonCell: UITableViewCell {
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
