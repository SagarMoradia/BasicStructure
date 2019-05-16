//
//  ThemeView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 07/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class blackLabelCtrlModel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
        if Device.IS_IPHONE_XS_MAX{
            let fnt : UIFont = self.font
            var sz : CGFloat = fnt.pointSize
            sz = sz + (sz*20/100)
            self.font = UIFont(name: fnt.fontName, size: sz)!
        }else if Device.IS_IPHONE_X{
            let fnt : UIFont = self.font
            var sz : CGFloat = fnt.pointSize
            sz = sz + (sz*10/100)
            self.font = UIFont(name: fnt.fontName, size: sz)
        }else if Device.IS_IPHONE_6P{
            let fnt : UIFont = self.font
            var sz : CGFloat = fnt.pointSize
            sz = sz + (sz*10/100)
            self.font = UIFont(name: fnt.fontName, size: sz)
        }
    }
    
    func setup() {
        
        var dictTheme: Themes!
        
        for theme in GLOBAL.sharedInstance.arrThemes {
            if theme.themeID == GLOBAL.sharedInstance.strSelectedThemeID && theme.themeName == GLOBAL.sharedInstance.strSelectedThemeName{
                dictTheme = theme
            }
        }
        
        
        //Background Color
        let r = dictTheme.themeProperties?.blackLabelCtrl?.labelBackgroundColor?.r ?? "0"
        let g = dictTheme.themeProperties?.blackLabelCtrl?.labelBackgroundColor?.g ?? "0"
        let b = dictTheme.themeProperties?.blackLabelCtrl?.labelBackgroundColor?.b ?? "0"
        let a = dictTheme.themeProperties?.blackLabelCtrl?.labelBackgroundColor?.a ?? "1"
        
        let bgColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
        self.backgroundColor = bgColor
        
        //Background Color
        let r1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.r ?? "0"
        let g1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.g ?? "0"
        let b1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.b ?? "0"
        let a1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.a ?? "1"
        
        let txtColor = UIColor.init(red: r1, green: g1, blue: b1, alpha: a1)
        self.textColor = txtColor
    }
    
}
