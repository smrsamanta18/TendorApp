//
//  NotificationListCell.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class NotificationListCell: UITableViewCell
{

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    override func awakeFromNib(){
        super.awakeFromNib()
        userIcon.layer.masksToBounds = false
        userIcon.layer.cornerRadius = userIcon.frame.height/2
        userIcon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func intializeCellDetails(CellDic : NotificationList){
        if let date = CellDic.date {
            let dd = dateFormator(value: date)
            lblDate.text = dd
        }
        if let msg = CellDic.message {
            lblNotification.text = msg
        }
    }
    
    func dateFormator(value : String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: value ) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
            return ""
        }
    }
}
