//
//  EHTextField.swift
//  EagleHills
//
//  Created by Sagar Moradia on 15/05/18.
//  Copyright © 2018 Sagar Moradia. All rights reserved.
//

import UIKit

@IBDesignable
class TWTextField: UITextField {

    func setup() {
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
        self.layer.borderWidth = CGFloat(1.0)
        self.layer.cornerRadius = CGFloat(3.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    
//    @IBInspectable var leftImage : UIImage?{
//        didSet {
//            updateView()
//        }
////        set{
////            updateView()
////        }
////        get{
////            return self.leftImage
////        }
//    }

    
    
//    func updateView(){
//
//        if let image = leftImage {
//
//            self.textColor = UIColor.white
//            self.tintColor = UIColor.white
//
//            if Device.IS_IPHONE_XS_MAX{
//                let fnt : UIFont = self.font!
//                var sz : CGFloat = fnt.pointSize
//                sz = sz + (sz*20/100)
//                self.font = UIFont(name: fnt.fontName, size: sz)
//            }else if Device.IS_IPHONE_X{
//                let fnt : UIFont = self.font!
//                var sz : CGFloat = fnt.pointSize
//                sz = sz + (sz*10/100)
//                self.font = UIFont(name: fnt.fontName, size: sz)
//            }
//
//            leftViewMode = .always
//
//            let imageHeight: CGFloat = 20.0
//            let imageWidth: CGFloat = 20.0
//
//            //            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: ((self.frame.height/2) - (imageHeight/2)), width: imageWidth, height: imageHeight))
//            //            imageView.image = image
//
//            let viewWidth: CGFloat = 30.0 //leftPadding + 25.0
//            let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: self.frame.height))
//
//            //            let imageView = UIImageView(frame: CGRect(x: ((view.frame.width/2) - (imageWidth/2)), y: ((view.frame.height/2) - (imageHeight/2)), width: imageWidth, height: imageHeight))
//            let imageView = UIImageView(frame: CGRect(x: 0, y: ((view.frame.height/2) - (imageHeight/2)), width: imageWidth, height: imageHeight))
//            imageView.image = image
//
//            //for line after image
//            let lineHeight: CGFloat = imageHeight+10.0
//            let lineView = UIView(frame: CGRect(x: ((viewWidth/2)+(viewWidth*(2/3)/2)-2), y: ((view.frame.height/2) - (lineHeight/2)), width: 1, height: lineHeight))
//            lineView.backgroundColor = UIColor.init(red: 108.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 1.0)
//            lineView.alpha = 0.0
//
//
//            let underLineHeight : CGFloat = 1.0
//            let underLineView = UIView(frame: CGRect(x: 0.0, y: self.frame.height - 1.0, width: self.frame.width, height: underLineHeight))
//            underLineView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
//            underLineView.alpha = 0.0
//
//
//            view.addSubview(imageView)
//            view.addSubview(lineView)
//            view.addSubview(underLineView)
//
//            leftView = view
//
//        }else{
//            leftViewMode = .never
//        }
//
//        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor : tintColor])
//    }
    
    
    
//    @IBInspectable var leftPadding : CGFloat = 0.0 {
//        didSet {
//            updateView()
//        }
//    }
    
}
