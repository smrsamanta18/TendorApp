//
//  MessageDetailsVC.swift
//  TendorApp
//
//  Created by Samir Samanta on 05/02/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MessageDetailsVC: BaseViewController {

    @IBOutlet weak var msgBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var msgVIew: RoundUIView!
    @IBOutlet weak var msgViewConstant: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    lazy var viewModel: MessageVM = {
        return MessageVM()
    }()
    var messageDetails : [MessageDetailsArray]?
    var tid : String?
    var contactName : String?
    var messsageTitle : String?
    var receoverID : String?
    
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var txtMessageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        headerSetup()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SenderCellT", bundle: Bundle.main), forCellReuseIdentifier: "SenderCellT")
        self.tableView.register(UINib(nibName: "ReciverCell", bundle: Bundle.main), forCellReuseIdentifier: "ReciverCell")
        // Do any additional setup after loading the view.
        self.initializeViewModel()
        self.getMessageListDetails()
        msgTxtView.delegate = self
        tabBarView.isHidden = true
        IQKeyboardManager.shared.enable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageDetailsVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageDetailsVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //msgTxtView.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if msgBottomConstraint.constant == 10 {
                    msgBottomConstraint.constant = keyboardSize.height + 100
                    print(msgBottomConstraint.constant)
                }
            }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if msgBottomConstraint.constant != 10 {
                        //msgBottomConstraint.constant -= keyboardSize.height
                        msgBottomConstraint.constant = 10
                    }
                }
    }
    
    func headerSetup()
    {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Message"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgProfileIcon.image = UIImage(named:"category-icon")
        tabBarView.inboxImg.image = UIImage(named: "InboxSelect")
    }
    @IBAction func btnSendAction(_ sender: Any) {
        if msgTxtView.text == "Type a message" {
            
        }else{
            txtMessageField.resignFirstResponder()
            let obj = ChatParam()
            obj.action = "chat"
            obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
            obj.tid = tid
            obj.message = msgTxtView.text
            obj.receiver = messageDetails![0].sender
            viewModel.postMessageDetailsToAPIService(user: obj)
        }
    }
    
    func getMessageListDetails(){
        self.view.endEditing(true)
        msgViewConstant.constant = 45
        let obj = MessageDetailsParam()
        obj.action = "message-list"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.tid = tid
        viewModel.getMessageDetailsToAPIService(user: obj)
    }
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                //let arrayList = (self?.viewModel.MessageDetails.messageDetailsList)!.reversed()
                self!.messageDetails = (self?.viewModel.MessageDetails.messageDetailsList)!.reversed()
                if self!.messageDetails!.count > 0 {
                    self!.lblName.text = self!.contactName
                    self!.serviceName.text = self!.messsageTitle
                    self!.tableView.reloadData()
                    let indexPath = IndexPath(item: self!.messageDetails!.count - 1, section: 0)
//                    self!.tableView.reloadRows(at: [indexPath], with: .bottom)
                    self!.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
        
        viewModel.refreshChatViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if self!.viewModel.chatDetails.message != nil {
                    self!.getMessageListDetails()
                    self!.txtMessageField.text = ""
                    self!.msgTxtView.text = "Type a message"
                }
            }
        }
    }
}

extension MessageDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageDetails != nil && messageDetails!.count > 0 {
            return messageDetails!.count
        }else{
            return 0
        }
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let senderId = messageDetails![indexPath.row].sender
        if senderId == AppPreferenceService.getString(PreferencesKeys.userID) {
            let receiverCell = tableView.dequeueReusableCell(withIdentifier: "ReciverCell") as! ReciverCell
            receiverCell.intializeCellDetails(cellDic: messageDetails![indexPath.row])
            return receiverCell
        }else{
            let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCellT") as! SenderCellT
            senderCell.intializeCellDetails(cellDic: messageDetails![indexPath.row])
            return senderCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messageDetails![indexPath.row].message!.count > 50 {
            return UITableView.automaticDimension
        }else{
            return 65
        }
    }
}
extension MessageDetailsVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        if txtMessageField.text!.count > 60 {
            if txtMessageField.text!.count > 90 {
                msgViewConstant.constant = 130
            }else{
                msgViewConstant.constant = 90
            }
        }else{
            msgViewConstant.constant = 45
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension MessageDetailsVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTxtView.text == "Type a message" {
            msgTxtView.text = ""
        }
        print("print1")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
       if msgTxtView.text!.count > 40 {
            if msgTxtView.text!.count > 90 {
                msgViewConstant.constant = 130
            }else{
                msgViewConstant.constant = 90
            }
        }else{
            msgViewConstant.constant = 45
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")        
        if msgTxtView.text == "" {
            msgTxtView.text = "Type a message"
            msgViewConstant.constant = 45
        }else{
            
        }
        msgBottomConstraint.constant = 10
    }
}
