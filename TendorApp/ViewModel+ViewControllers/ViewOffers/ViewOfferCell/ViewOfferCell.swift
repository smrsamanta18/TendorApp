//
//  ViewOfferCell.swift
//  TendorApp
//
//  Created by Asif Dafadar on 31/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class ViewOfferCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var offerDetailsBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        offerDetailsBtn.backgroundColor = .black
        offerDetailsBtn.layer.cornerRadius = 6
        offerDetailsBtn.layer.borderWidth = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func offerDetailsAction(_ sender: Any) {
    }
    
}
