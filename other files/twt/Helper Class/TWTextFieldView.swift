//
//  TWTextFieldView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class TWTextFieldView: UIView {

    var titleLable = blackLabelCtrlModel()
    var txtField = textViewCtrlModel()
    var rightView = UIView()
    var errorLable = UILabel()
    var errorMessage = String()
    
    var blackLabelThemeColor          = UIColor()
    var blackLabelBgThemeColor        = UIColor()
    var txtfieldTextThemeColor        = UIColor()
    var txtfieldPlaceholderThemeColor = UIColor()
    var txtfieldBorderThemeColor      = UIColor()
    var txtfieldBackgroundThemeColor  = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextFieldView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTextFieldView()
    }
    
    override func draw(_ rect: CGRect) {
        setTextFieldColors()
        setLableColors()
        setTextFieldView()
        addRightImage()
    }
    
    @IBInspectable var title : String?{
        didSet {
            setTextFieldView()
        }
//        set{
//            setTextFieldView()
//        }
//        get{
//            return ""
//        }
    }
    
    @IBInspectable var titleColor : UIColor?{
        didSet {
            setTextFieldView()
        }
//        set{
//            setTextFieldView()
//        }
//        get{
//            return UIColor.clear
//        }
    }
    
    @IBInspectable var txtPlaceholder : String?{
        didSet {
            setTextFieldView()
        }
//        set{
//            setTextFieldView()
//        }
//        get{
//            return ""
//        }
    }
    
    @IBInspectable var txtColor : UIColor?{
        didSet {
            setTextFieldView()
        }
//        set{
//            setTextFieldView()
//        }
//        get{
//            return UIColor.clear
//        }
    }
    
    @IBInspectable var paddingRight : CGFloat = 0{
        didSet {
            setTextFieldView()
        }
        //        set{
        //            setTextFieldView()
        //        }
        //        get{
        //            return UIColor.clear
        //        }
    }
    
    var isValidate:Bool?
    {
        didSet {
            if isValidate!{
                self.errorLable.alpha = 0.0
                self.titleLable.textColor = UIColor.textColor_black //self.blackLabelThemeColor //
                self.txtField.textColor = txtColor //self.txtfieldTextThemeColor //
                self.txtField.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor //self.txtfieldBorderThemeColor.cgColor //
            }else{
                self.errorLable.alpha = 1.0
                self.errorLable.text = errorMessage
                self.titleLable.textColor = UIColor.txtfieldBorder_red
                self.txtField.textColor = UIColor.txtfieldBorder_red
                self.txtField.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            }
        }
    }
    
    @IBInspectable var rightImage : UIImage?{
        didSet {
            //addRightImage()
        }
    }
    
    @IBInspectable var removeImageView : UIView?{
        didSet {
            
        }
    }
    
    func setTextFieldView(){
        
        titleLable.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: 20.0)
        titleLable.font = fontType.InterUI_Medium_13
        titleLable.textColor = titleColor //self.blackLabelThemeColor //
        titleLable.text = title
        //titleLable.backgroundColor = UIColor.lightGray
        
        //rightView.frame = CGRect(x: 0, y: titleLable.frame.maxY+3.0, width: self.frame.width, height: 40.0)
        txtField.layer.masksToBounds = true
//        rightView.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor //self.txtfieldBorderThemeColor.cgColor //
//        rightView.layer.borderWidth = CGFloat(1.0)
//        rightView.layer.cornerRadius = CGFloat(3.0)
        
        //txtField.frame = CGRect(x: 0, y: 0, width: rightView.frame.width - 30, height: 40.0)
        txtField.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: paddingRight)
        txtField.frame = CGRect(x: 0, y: titleLable.frame.maxY+3.0, width: self.frame.width, height: 40.0)
        txtField.placeholder = txtPlaceholder
        txtField.font = fontType.InterUI_Medium_13
        txtField.textColor = txtColor //self.txtfieldTextThemeColor //
        txtField.layer.masksToBounds = true
        txtField.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor //self.txtfieldBorderThemeColor.cgColor //
        txtField.layer.borderWidth = CGFloat(1.0)
        txtField.layer.cornerRadius = CGFloat(3.0)
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        //txtField.backgroundColor = UIColor.black

        errorLable.frame = CGRect(x: 0.0, y: txtField.frame.maxY, width: self.frame.width, height: 20.0)
        errorLable.font = fontType.InterUI_Regular_12 //UIFont(name: "Inter-UI-Medium", size: 10.0) //
        errorLable.textColor = UIColor.txtfieldBorder_red
//        errorLable.numberOfLines = 0
//        errorLable.lineBreakMode = .byWordWrapping
        //errorLable.backgroundColor = UIColor.darkGray
        
        //self.backgroundColor = UIColor.btn_bg_extraLight_green
        
        self.addSubview(titleLable)
        //self.addSubview(rightView)
        //rightView.addSubview(txtField)
        self.addSubview(txtField)
        self.addSubview(errorLable)
        
    }
    
    func addRightImage() {
        
        if let image = rightImage {
            
            let viewWidth: CGFloat = 30.0
            let view = UIView(frame: CGRect(x: self.txtField.frame.width-(viewWidth+10.0), y: 0.0, width: viewWidth, height: self.txtField.frame.height))
            view.tag = 123
            view.backgroundColor = UIColor.white
            view.isUserInteractionEnabled = false
            let imageHeight: CGFloat = 15.0
            let imageWidth: CGFloat = 15.0
            let imageView = UIImageView(frame: CGRect(x: ((view.frame.width/2) - (imageWidth/2)), y: ((view.frame.height/2) - (imageHeight/2)), width: imageWidth, height: imageHeight))
            imageView.tag = 123
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = image
            
            view.addSubview(imageView)
            self.txtField.addSubview(view)
        }
    }
    /*
    func removeRightImage()  {
        
//        if let image = rightImage {
        
            let viewWidth: CGFloat = 30.0
            let view = UIView(frame: CGRect(x: self.rightView.frame.width-(viewWidth+10.0), y: 0.0, width: viewWidth, height: self.rightView.frame.height))
            view.tag = 123
            view.backgroundColor = UIColor.white
            view.isUserInteractionEnabled = false
            let imageHeight: CGFloat = 15.0
            let imageWidth: CGFloat = 15.0
            let imageView = UIImageView(frame: CGRect(x: ((view.frame.width/2) - (imageWidth/2)), y: ((view.frame.height/2) - (imageHeight/2)), width: imageWidth, height: imageHeight))
            imageView.tag = 123
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "white_icon")
            
            view.addSubview(imageView)
            self.rightView.addSubview(view)
//        }
        
//        DispatchQueue.main.async {
//            for subview in self.rightView.subviews{
//                if subview .isKind(of: UIImageView.self) {
//                    subview.removeFromSuperview()
//                }
//            }
//        }
    }
 */
    
    func removeRightImage()  {
        DispatchQueue.main.async {
            for subview in self.txtField.subviews{
                subview.removeFromSuperview()
            }
        }
    }
    
    func setTextFieldColors() {
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
        self.txtfieldBackgroundThemeColor = bgColor
        
        //Text color
        let r1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.r ?? "0"
        let g1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.g ?? "0"
        let b1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.b ?? "0"
        let a1 = dictTheme.themeProperties?.textViewCtrl?.textForegroundColor?.a ?? "1"
        
        let txtColor = UIColor.init(red: r1, green: g1, blue: b1, alpha: a1)
        self.txtfieldTextThemeColor = txtColor
//        self.txtfieldPlaceholderThemeColor = txtColor
        
        //Border color
        let r2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.r ?? "0"
        let g2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.g ?? "0"
        let b2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.b ?? "0"
        let a2 = dictTheme.themeProperties?.textViewCtrl?.textBorderColor?.a ?? "1"
        
        let borderColor = UIColor.init(red: r2, green: g2, blue: b2, alpha: a2)
        self.txtfieldBorderThemeColor = borderColor
    }
    
    func setLableColors() {
        
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
        self.blackLabelBgThemeColor = bgColor
        
        //Background Color
        let r1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.r ?? "0"
        let g1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.g ?? "0"
        let b1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.b ?? "0"
        let a1 = dictTheme.themeProperties?.blackLabelCtrl?.labelForegroundColor?.a ?? "1"
        
        let txtColor = UIColor.init(red: r1, green: g1, blue: b1, alpha: a1)
        self.blackLabelThemeColor = txtColor
    }
}
