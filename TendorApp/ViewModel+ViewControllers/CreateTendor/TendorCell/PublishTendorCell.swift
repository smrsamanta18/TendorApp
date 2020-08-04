//
//  PublishTendorCell.swift
//  TendorApp
//
//  Created by Samir Samanta on 29/01/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
protocol signUpDelegates {
    
    func selectCountry()
    func selectType()
    func selectCategory()
    func selectClosingDate()
    func selectDocumentDate()
}

class PublishTendorCell: UITableViewCell {

    @IBOutlet weak var imgUploadIcon: UIImageView!
    @IBOutlet weak var lblImgName: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var dropDownBtnOutlet: UIButton!
    @IBOutlet weak var txtFieldVAlue: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    var dobDelegates : signUpDelegates?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImgView.layer.masksToBounds = false
        productImgView.layer.cornerRadius = 5
        productImgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func dropDownButtonAction(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 1:
            dobDelegates?.selectType()
        case 2:
            dobDelegates?.selectCategory()
        case 3:
            dobDelegates?.selectCountry()
        case 5:
            dobDelegates?.selectClosingDate()
        case 6:
            dobDelegates?.selectDocumentDate()
        default:
            break
        }
    }
}
