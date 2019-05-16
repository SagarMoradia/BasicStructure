//
//  Color+Extension.swift
//  MyUS
//
//  Created by Hitesh Surani on 11/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import UIKit

extension UIColor{
    
    //Navigation Color
    static let theme_black             = UIColor(red: 0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha: 1.0)
    static let theme_gray_New             = UIColor(red: 38.0/255.0, green:38.0/255.0, blue:38.0/255.0, alpha: 1.0)

    //Default Theme
    static let theme_green                = UIColor(red: 0.0/255.0, green:84.0/255.0, blue:42.0/255.0, alpha: 1.0)
    static let textColor_black            = UIColor(red: 17.0/255.0, green:17.0/255.0, blue:17.0/255.0, alpha: 1.0)
    static let textColor_gray             = UIColor(red: 134.0/255.0, green:134.0/255.0, blue:134.0/255.0, alpha: 1.0)
    static let btn_bg_extraLight_green    = UIColor(red: 244.0/255.0, green:249.0/255.0, blue:247.0/255.0, alpha: 1.0)
    static let textColor_blue             = UIColor(red: 28.0/255.0, green:126.0/255.0, blue:218.0/255.0, alpha: 1.0)
    static let textColor_black_unselected = UIColor(red: 17.0/255.0, green:17.0/255.0, blue:17.0/255.0, alpha: 0.5)
    static let textColor_light_white      = UIColor(red: 255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 0.5)
    
    static let txtfieldBorder_gray = UIColor(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha: 1.0)
    static let txtfieldBorder_red = UIColor(red: 209.0/255.0, green:0.0/255.0, blue:51.0/255.0, alpha: 1.0)
    
    static let theme_gray        = UIColor(red: 38.0/255.0, green:42.0/255.0, blue:46.0/255.0, alpha: 1.0)
    static let placeholder_color = UIColor(red: 199.0/255.0, green:199.0/255.0, blue:204.0/255.0, alpha: 1.0)
    static let shadow_color      = UIColor(red: 136.0/255.0, green:136.0/255.0, blue:136.0/255.0, alpha: 1.0)
    
    
    //Dark Theme
    static let theme_dark = UIColor(red: 34.0/255.0, green:34.0/255.0, blue:34.0/255.0, alpha: 1.0)
    static let btn_bg_green = UIColor(red: 0.0/255.0, green:166.0/255.0, blue:83.0/255.0, alpha: 1.0)
    
    //Seprator
    static let seperator_color = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    static let border_color = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    static let white_border_color = UIColor.init(red: 244.0/255.0, green: 249.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexValue: Int) {
        self.init(
            red: (hexValue >> 16) & 0xFF,
            green: (hexValue >> 8) & 0xFF,
            blue: hexValue & 0xFF
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hexValue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (hexValue >> 16) & 0xFF,
            green: (hexValue >> 8) & 0xFF,
            blue: hexValue & 0xFF,
            alpha: alpha
        )
    }
    
    convenience init(red: String, green: String, blue: String, alpha: String) {
        
        var r = CGFloat()
        if let r1 = NumberFormatter().number(from: red) {
            r = CGFloat(truncating: r1)
        }
        
        var g = CGFloat()
        if let g1 = NumberFormatter().number(from: green) {
            g = CGFloat(truncating: g1)
        }
        
        var b = CGFloat()
        if let b1 = NumberFormatter().number(from: blue) {
            b = CGFloat(truncating: b1)
        }
        
        var a = CGFloat()
        if let a1 = NumberFormatter().number(from: alpha) {
            a = CGFloat(truncating: a1)
        }
        
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: a
        )
    }
    
    convenience init(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    }
}

