//
//  ThemeTextField.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class textViewCtrlModel: UITextField {
    
    @IBInspectable var padding_right: CGFloat {
        get {
            return 0
        }
        set (f) {
            layer.sublayerTransform = CATransform3DMakeTranslation(f, 0, 0)
        }
    }

    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
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
        let r = dictTheme.themeProperties?.textViewCtrl?.textBackgroundColor?.r ?? "0"
        let g = dictTheme.themeProperties?.textViewCtrl?.textBackgroundColor?.g ?? "0"
        let b = dictTheme.themeProperties?.textViewCtrl?.textBackgroundColor?.b ?? "0"
        let a = dictTheme.themeProperties?.textViewCtrl?.textBackgroundColor?.a ?? "1"

        let bgColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
        self.backgroundColor = bgColor

        //Text color
        let r1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.r ?? "0"
        let g1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.g ?? "0"
        let b1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.b ?? "0"
        let a1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.a ?? "1"

        let txtColor = UIColor.init(red: r1, green: g1, blue: b1, alpha: a1)
        self.textColor = txtColor
        
        //Border color
        let r2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.r ?? "0"
        let g2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.g ?? "0"
        let b2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.b ?? "0"
        let a2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.a ?? "1"
        
        let borderColor = UIColor.init(red: r2, green: g2, blue: b2, alpha: a2)
        self.layer.borderColor = borderColor.cgColor
    }
}
