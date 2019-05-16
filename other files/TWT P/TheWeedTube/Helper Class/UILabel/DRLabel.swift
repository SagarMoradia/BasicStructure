//
//  DRLabel.swift
//  DELRentals
//
//  Created by Sweta Vani on 11/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import UIKit

@IBDesignable
class DRLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
        }
    }

}

class SMPaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
    
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect.inset(by: insets))
    }
}
