//
//  ReciverCell.swift
//  TendorApp
//
//  Created by Samir Samanta on 05/02/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class ReciverCell: UITableViewCell {

    @IBOutlet weak var recieverImg: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReceiverMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recieverImg.layer.masksToBounds = false
        recieverImg.layer.cornerRadius = recieverImg.frame.height/2
        recieverImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func intializeCellDetails(cellDic : MessageDetailsArray){
        if let iconURL = cellDic.receiver_logo {
            let fullURL = iconURL
            recieverImg.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "profileDefault"))
        }
        lblDate.text = cellDic.msg_date
        lblReceiverMsg.text = cellDic.message
    }
    
    func dateFormator(value : String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM dd,yyyy HH:mm a"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm a"
        dateFormatterPrint.amSymbol = "AM"
        dateFormatterPrint.pmSymbol = "PM"
        
        if let date = dateFormatterGet.date(from: value ) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
            return ""
        }
    }

}
