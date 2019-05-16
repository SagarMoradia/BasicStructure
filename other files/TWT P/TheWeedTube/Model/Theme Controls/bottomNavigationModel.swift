//
//  ThemeTextField.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class bottomNavigationModel: UITabBar {

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
        let r = dictTheme.themeProperties?.bottomNavigation?.backgroundColor?.r ?? "0"
        let g = dictTheme.themeProperties?.bottomNavigation?.backgroundColor?.g ?? "0"
        let b = dictTheme.themeProperties?.bottomNavigation?.backgroundColor?.b ?? "0"
        let a = dictTheme.themeProperties?.bottomNavigation?.backgroundColor?.a ?? "1"

        let bgColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
        self.backgroundColor = bgColor

        //Foreground color
        let r1 = dictTheme.themeProperties?.bottomNavigation?.forgroundColor?.r ?? "0"
        let g1 = dictTheme.themeProperties?.bottomNavigation?.forgroundColor?.g ?? "0"
        let b1 = dictTheme.themeProperties?.bottomNavigation?.forgroundColor?.b ?? "0"
        let a1 = dictTheme.themeProperties?.bottomNavigation?.forgroundColor?.a ?? "1"

        let fColor = UIColor.init(red: r1, green: g1, blue: b1, alpha: a1)
        print(fColor)
    }
}
