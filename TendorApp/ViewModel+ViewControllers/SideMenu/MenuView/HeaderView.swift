//
//  HeaderView.swift
//  MUC
//
//  Created by Shyam Future Tech on 16/07/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
protocol headerMenuActionDelegate {
    func homeMneu()
}
class HeaderView: UIView {
    
    
    @IBOutlet var headerContentView: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgViewMenu: UIImageView!
    @IBOutlet weak var imgProfileIcon: UIImageView!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var centerConstraintOutlet: NSLayoutConstraint!
    var homeDelegate : headerMenuActionDelegate?
    @IBOutlet weak var notificationValueView: RoundUIView!
    var onClickSideMenuButtonAction: (() -> Void)? = nil
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
        
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(headerContentView)
        headerContentView.frame = self.bounds
        headerContentView.autoresizingMask = .flexibleHeight
    }
    
    @IBAction func sideMenuButtonAction(_ sender: Any) {
        if self.onClickSideMenuButtonAction != nil{
            self.onClickSideMenuButtonAction!()
        }
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
//        if self.onClickProfileButtonAction != nil{
//            self.onClickProfileButtonAction!()
//        }
        self.homeDelegate!.homeMneu()
    }
}
