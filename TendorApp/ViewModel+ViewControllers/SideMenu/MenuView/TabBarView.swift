//
//  TabBarView.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 08/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class TabBarView: UIView {
    
    @IBOutlet weak var lblNotication: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblInbox: UILabel!
    @IBOutlet weak var lblAddTendor: UILabel!
    @IBOutlet weak var lblMore: UILabel!
    
    
    @IBOutlet var tabBarView: UIView!
    @IBOutlet weak var addTenderImg: UIImageView!
    @IBOutlet weak var moreImg: UIImageView!
    @IBOutlet weak var notificationImg: UIImageView!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var inboxImg: UIImageView!
    var onClickHomeButtonAction: (() -> Void)? = nil
    var onClickContactButtonAction: (() -> Void)? = nil
    var onClickMonitorButtonAction: (() -> Void)? = nil
    var onClickApplyButtonAction: (() -> Void)? = nil
    var onClickProfileButtonAction: (() -> Void)? = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TabBarView", owner: self, options: nil)
        addSubview(tabBarView)
        tabBarView.frame = self.bounds
        tabBarView.autoresizingMask = .flexibleHeight
    }
    
    
    @IBAction func btnHomeAction(_ sender: Any) {
        if self.onClickHomeButtonAction != nil{
            self.onClickHomeButtonAction!()
        }
    }
    
    @IBAction func btnContactAction(_ sender: Any) {
        if self.onClickContactButtonAction != nil{
            self.onClickContactButtonAction!()
        }
    }
    @IBAction func btnMonitorAction(_ sender: Any) {
        if self.onClickMonitorButtonAction != nil{
            self.onClickMonitorButtonAction!()
        }
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        if self.onClickApplyButtonAction != nil{
            self.onClickApplyButtonAction!()
        }
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        if self.onClickProfileButtonAction != nil{
            self.onClickProfileButtonAction!()
        }
    }
}
