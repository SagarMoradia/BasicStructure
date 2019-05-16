
//
//  ForgotPasswordSuccessVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 12/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class ForgotPasswordSuccessVC: ParentVC {

    //MARK: - Outlets
    @IBOutlet weak var lblSuccessMsg: UILabel!
    
    var emailID = String()

    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Intial Methods
    private func prepareViews() {        
        let msg = "A link to reset your password has been sent to "
        lblSuccessMsg.text = msg + emailID
    }
    
    //MARK: - Action Methods
    @IBAction func btnLoginTap(_ sender: UIButton) {
        if !POP_TO_VC(controllerClass: LoginVC.self){
            self.redirctToLoginScreen()
        }
    }
}
