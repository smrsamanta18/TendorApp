//
//  TendorCell.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class TendorCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var imgSeparator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
