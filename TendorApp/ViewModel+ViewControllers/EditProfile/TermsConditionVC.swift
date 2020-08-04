//
//  TermsConditionVC.swift
//  TendorApp
//
//  Created by Shyam Future Tech on 11/05/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import WebKit
class TermsConditionVC: BaseViewController {

    @IBOutlet weak var termsWebView: WKWebView!
    var urlValue : String?
    var headerValue : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        termsWebView.load(NSURLRequest(url: NSURL(string: urlValue!)! as URL) as URLRequest)
        
        //headerView.homeDelegate = self
        tabBarView.isHidden = true
        headerView.lblHeaderTitle.text = headerValue
        headerView.imgProfileIcon.isHidden = true
        headerView.imgProfileIcon.image = UIImage(named: "EditeIcon")
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
    }
}
