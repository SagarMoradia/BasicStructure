//
//  ThemeView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 07/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class uploadingLightGreenViewCtrlModel: UIView {

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
        let r = dictTheme.themeProperties?.uploadingLightGreenViewCtrl?.viewBackgroundColor?.r ?? "0"
        let g = dictTheme.themeProperties?.uploadingLightGreenViewCtrl?.viewBackgroundColor?.g ?? "0"
        let b = dictTheme.themeProperties?.uploadingLightGreenViewCtrl?.viewBackgroundColor?.b ?? "0"
        let a = dictTheme.themeProperties?.uploadingLightGreenViewCtrl?.viewBackgroundColor?.a ?? "1"
        
        let bgColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
        self.backgroundColor = bgColor
    }
    
}
