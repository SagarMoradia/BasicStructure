//
//  ThemeView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 07/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

//class Foo: NSObject {
//    @objc dynamic var bar = 0
//}

class viewControlModel: UIView {

//    var themeChanged = Foo()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addObserver(self, forKeyPath: "themeChanged", options: [.new, .old], context: nil)
        
        setup()
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        setup()
//    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        addObserver(self, forKeyPath: "themeChanged", options: [.new, .old], context: nil)
        
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
        let r = dictTheme.themeProperties?.viewControl?.viewBackgroundColor?.r ?? "0"
        let g = dictTheme.themeProperties?.viewControl?.viewBackgroundColor?.g ?? "0"
        let b = dictTheme.themeProperties?.viewControl?.viewBackgroundColor?.b ?? "0"
        let a = dictTheme.themeProperties?.viewControl?.viewBackgroundColor?.a ?? "1"
        
        let bgColor = UIColor.init(red: r, green: g, blue: b, alpha: a)
        self.backgroundColor = bgColor
    }
    
}
