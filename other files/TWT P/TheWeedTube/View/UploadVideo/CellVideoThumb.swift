//
//  CellVideoThumb.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 27/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellVideoThumb: UICollectionViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var viewCamera : UIView!
    @IBOutlet weak var viewSelected : UIControl!
    @IBOutlet weak var lblCamera : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        if Device.IS_IPHONE_X{
//            lblCamera.font = UIFont(name: "InterUI-Medium",
//                                    size: 13.0)
//        }else{
//            
//        }
    }

}
