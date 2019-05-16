//
//  DRButton.swift
//  DELRentals
//
//  Created by Sweta Vani on 11/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DRButton: UIButton {
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if Device.IS_IPHONE_XS_MAX{
            let fnt : UIFont = (self.titleLabel?.font)!
            var sz : CGFloat = fnt.pointSize
            sz = sz + (sz*20/100)
            self.titleLabel?.font = UIFont(name: fnt.fontName, size: sz)!
        }else if Device.IS_IPHONE_X{
            let fnt : UIFont = (self.titleLabel?.font!)!
            var sz : CGFloat = fnt.pointSize
            sz = sz + (sz*10/100)
            self.titleLabel?.font = UIFont(name: fnt.fontName, size: sz)
        }
    }
}
