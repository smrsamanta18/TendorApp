//
//  WelcomeVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 24/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func btnSignInTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func skipButton(_ sender: Any) {
        AppPreferenceService.removeString(PreferencesKeys.userName)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}
