//
//  ProfileCell.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 09/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
protocol profileImageCaptureDelegate {
    func captureImage()
}
class ProfileCell: UITableViewCell {

    
    @IBOutlet weak var backroundView: RoundUIView!
    @IBOutlet weak var lblImgName: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UITextField!
    //    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var imgSeparator: UIImageView!
    @IBOutlet weak var profileIconImg: UIImageView!
    
    @IBOutlet weak var profileBtnOutlet: UIButton!
    var delegate : profileImageCaptureDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImgView.layer.masksToBounds = false
        profileImgView.layer.cornerRadius = 5
        profileImgView.clipsToBounds = true
        
        
        profileIconImg.layer.masksToBounds = false
        profileIconImg.layer.borderColor = UIColor.white.cgColor
        profileIconImg.layer.cornerRadius = profileIconImg.frame.size.width / 2
        profileIconImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func profileBtnAcion(_ sender: Any) {
        delegate!.captureImage()
    }
}
