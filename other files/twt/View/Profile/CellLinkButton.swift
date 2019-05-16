//
//  CellLinkButton.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 18/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellLinkButton: UICollectionViewCell {
    
    @IBOutlet weak var imgvBtn: UIImageView!
    @IBOutlet weak var btnLink: UIButton!
    
    var objclassSocial:classSocial!{
        didSet {
            imgvBtn.image = UIImage.init(named: objclassSocial.imgIcon.lowercased())
        }
    }
}
