//
//  ProfileCell.swift
//  TendorApp
//
//  Created by Samir Samanta on 29/01/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblFieldValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
