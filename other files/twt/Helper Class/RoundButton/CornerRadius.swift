//
//  CornerRadius.swift
//  Capchur
//
//  Created by Hitesh Surani on 26/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation
import UIKit

class CornerRadius: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = self.frame.height/2
        clipsToBounds = true
//        self.backgroundColor = UIColor.init(hex: "03a51b")
    }
}
