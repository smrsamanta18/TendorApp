//
//  SenderCellT.swift
//  TendorApp
//
//  Created by Samir Samanta on 05/02/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class SenderCellT: UITableViewCell {

    @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMsgBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderImg.layer.masksToBounds = false
        senderImg.layer.cornerRadius = senderImg.frame.height/2
        senderImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func intializeCellDetails(cellDic : MessageDetailsArray){
        if let iconURL = cellDic.sender_logo {
            let fullURL = iconURL
            senderImg.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "profileDefault"))
        }
        lblDate.text = cellDic.msg_date
        lblMsgBody.text = cellDic.message
    }
}
