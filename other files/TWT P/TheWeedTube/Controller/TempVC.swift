//
//  TempVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 04/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class TempVC: ParentVC {

    @IBOutlet weak var viewMain: viewControlModel!
    @IBOutlet weak var swtch: UISwitch!
    @IBOutlet weak var lblSample: UILabel!
    @IBOutlet weak var btnSample: ButtonControlModel!
    
    var isThemeChange = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if GLOBAL.sharedInstance.strSelectedThemeID == "1" {
            isThemeChange = false
        }else{
            isThemeChange = true
        }
        
        self.changeTheme()
        
        
    }
    
    func changeTheme() {
        
        if isThemeChange {
            
            print("Dark Theme")
            GLOBAL.sharedInstance.strSelectedThemeID = "2"
            GLOBAL.sharedInstance.strSelectedThemeName = "Dark"
            btnSample.setTitle("Change to Light", for: .normal)
            viewMain.setup()
            btnSample.setup()
        }else{
            
            print("Light Theme")
            GLOBAL.sharedInstance.strSelectedThemeID = "1"
            GLOBAL.sharedInstance.strSelectedThemeName = "Light"
            btnSample.setTitle("Change to Dark", for: .normal)
            viewMain.setup()
            btnSample.setup()
        }
    }
    
    @IBAction func swtchChange(_ sender: UISwitch) {
//        swtch.isOn = !swtch.isOn
//        self.changeTheme()
    }
    
    @IBAction func btnThemeTap(_ sender: UIButton) {
        isThemeChange = !isThemeChange
        self.changeTheme()
    }
    
}


