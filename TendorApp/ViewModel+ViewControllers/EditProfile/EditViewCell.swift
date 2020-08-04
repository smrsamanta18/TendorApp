//
//  EditViewCell.swift
//  TendorApp
//
//  Created by Samir Samanta on 29/01/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
protocol selectCountryListForEdit {
    func selectCountryList()
}

class EditViewCell: UITableViewCell {

    @IBOutlet weak var editTxtBtnView: UIButton!
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var txtFieldValue: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    var delegate : selectCountryListForEdit?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editTxtBtnAction(_ sender: Any) {
        delegate!.selectCountryList()
    }
}
