//
//  ProfileCell.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet weak var lblTendorId: UILabel!
    @IBOutlet weak var lblTendorClosingDate: UILabel!
    
    @IBOutlet weak var lblTendorDescription: UILabel!
    @IBOutlet weak var lblOpeningDate: UILabel!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCellDetails(cellDic : LatestTendorList){
        lblName.text = cellDic.title
        lblTendorId.text = "Tendor No. #" + cellDic.tid!
        lblTendorDescription.text = cellDic.tender_description
        let openingDate = dateFormator(value: cellDic.opening_date!)
        let ClosingDate = dateFormator(value: cellDic.exp_date!)
        lblOpeningDate.text = "Open Date: " + openingDate
        lblTendorClosingDate.text = "Close Date: " + ClosingDate
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
