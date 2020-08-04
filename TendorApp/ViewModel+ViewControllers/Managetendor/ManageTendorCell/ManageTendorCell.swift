//
//  ManageTendorCell.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class ManageTendorCell: UITableViewCell
{
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblClosingDate: UILabel!
    @IBOutlet weak var lblOpeningDate: UILabel!
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var lblTendorID: UILabel!
    @IBOutlet weak var lblTendorDescription: UILabel!
    @IBOutlet weak var lblTendorNAme: UILabel!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnManageOffer: UIButton!
    @IBOutlet weak var btnViewOffer: UIButton!
    @IBOutlet weak var btnAdditionalInfo: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func initializeCellDetails(cellDic : MyTendorList){
        lblTendorNAme.text = cellDic.title
        lblTendorDescription.text = cellDic.tender_description
        lblTendorID.text = "Ref No. #" + cellDic.tid!
        let openDate = dateFormator(value: cellDic.opening_date!)
        lblOpeningDate.text = "Open Date : " + openDate
        let closeDate = dateFormator(value: cellDic.exp_date!)
        lblClosingDate.text = "Close Date : " + closeDate
        lblStatus.text = "Close Date : " + cellDic.status!
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
