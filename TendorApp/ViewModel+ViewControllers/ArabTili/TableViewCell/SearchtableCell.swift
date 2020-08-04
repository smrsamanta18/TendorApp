//
//  SearchtableCell.swift
//  TendorApp
//
//  Created by Asif Dafadar on 24/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
protocol applyMethodDelegate {
    func applyDelegate()
    func fullImageDelegate()
}
class SearchtableCell: UITableViewCell {

    @IBOutlet weak var imgViewDetails: UIImageView!
    @IBOutlet weak var applyVIew: RoundUIView!
    @IBOutlet weak var lblClosingDate: UILabel!
    @IBOutlet weak var lblOpenDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTitile: UILabel!
    @IBOutlet weak var lblRefferanceNumber: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    var delegate : applyMethodDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewDetails.layer.borderWidth = 0
        imgViewDetails.layer.masksToBounds = false
        imgViewDetails.layer.cornerRadius = imgViewDetails.frame.height/2
        imgViewDetails.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func btnApplyAction(_ sender: Any) {
        delegate!.applyDelegate()
    }
    @IBAction func btnFullImage(_ sender: Any) {
        delegate!.fullImageDelegate()
        
    }
}


class SearchtableImageCell: UITableViewCell {

    @IBOutlet weak var tendorImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tendorImgView.layer.borderWidth = 0
        tendorImgView.layer.masksToBounds = false
        tendorImgView.layer.cornerRadius = tendorImgView.frame.height/2
        tendorImgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
