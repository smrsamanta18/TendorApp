//
//  MessageListCell.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMsgCount: UILabel!
    @IBOutlet weak var lblMsgFrom: UILabel!
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userIcon.layer.masksToBounds = false
        userIcon.layer.cornerRadius = userIcon.frame.height/2
        userIcon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func btnDeleteAction(_ sender: Any) {
        
    }
    
    func intializeCellDetails(cellDic : MessageListArray){
        if let iconURL = cellDic.logo {
            let fullURL = iconURL
            userIcon.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "profileDefault"))
        }
        if let name = cellDic.name {
            lblName.text = name
        }
        
        if let nameTitle = cellDic.title {
            lblMsgFrom.text = nameTitle
        }
        
        if let Msg = cellDic.message {
            lblMsg.text = Msg
        }
        if let date = cellDic.date {
            let time = dateFormator(value: date)
            lblTime.text = time
        }
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
