//
//  AgeVerificationView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

typealias AgeVerificationHandlerBlock = (( _ index:Int)->())?

class AgeVerificationView: UIView {

    //Callback
    var handler: AgeVerificationHandlerBlock!

    @IBOutlet weak var viewParent : UIView!
    @IBOutlet weak var viewMain : UIView!

    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!

    override func awakeFromNib() {
        self.bindToKeyboard()
        DispatchQueue.main.async {
            //self.setUpUI()
        }
    }
    
    //MARK: - Intial Methods
    func setUpUI() {
        btnYes.layer.masksToBounds = false
        btnYes.layer.cornerRadius = 3.4
        btnNo.layer.masksToBounds = false
        btnNo.layer.cornerRadius = 3.4
        btnNo.layer.borderWidth = 1.0
        btnNo.layer.borderColor = UIColor.theme_green.cgColor
    }
    
    //MARK: - Button Event Methods
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        
        self.viewParent.backgroundColor = UIColor.clear
        
        self.removeFromSuperviewWithAnimationCenter(animation: {
            
        }) {//Completion
            if self.handler != nil {
                self.handler!!(sender.tag)
                print("-----------------tag of sender:----------------",sender.tag)
            }
        }
        
    }
}
