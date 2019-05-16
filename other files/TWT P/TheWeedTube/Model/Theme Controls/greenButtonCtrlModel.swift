//
//  FollowBtnCtrl.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class greenButtonCtrlModel: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        var dictTheme: Themes!
        
        for theme in GLOBAL.sharedInstance.arrThemes {
            if theme.themeID == GLOBAL.sharedInstance.strSelectedThemeID && theme.themeName == GLOBAL.sharedInstance.strSelectedThemeName{
                dictTheme = theme
            }
        }
        
        //Background Color
        let r = dictTheme.themeProperties?.greenButtonCtrl?.buttonBackgroundColor?.r ?? "0"
        let g = dictTheme.themeProperties?.greenButtonCtrl?.buttonBackgroundColor?.g ?? "0"
        let b = dictTheme.themeProperties?.greenButtonCtrl?.buttonBackgroundColor?.b ?? "0"
        let a = dictTheme.themeProperties?.greenButtonCtrl?.buttonBackgroundColor?.a ?? "1"
        
        let bgColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
        self.backgroundColor = bgColor
        
        //Title color
        let r1 = dictTheme.themeProperties?.greenButtonCtrl?.buttonForegroundColor?.r ?? "0"
        let g1 = dictTheme.themeProperties?.greenButtonCtrl?.buttonForegroundColor?.g ?? "0"
        let b1 = dictTheme.themeProperties?.greenButtonCtrl?.buttonForegroundColor?.b ?? "0"
        let a1 = dictTheme.themeProperties?.greenButtonCtrl?.buttonForegroundColor?.a ?? "1"
        
        let titleColor = UIColor.init(red: r1, green: g1, blue: b1, alpha: a1)
        self.titleLabel?.textColor = titleColor
    }
}
