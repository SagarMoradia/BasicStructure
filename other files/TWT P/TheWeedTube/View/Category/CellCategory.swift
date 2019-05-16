//
//  CellCategory.swift
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class CellCategory: UITableViewCell {
    
    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var controlCategory: UIControl!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblVideoCount: UILabel!
    @IBOutlet weak var lblBadgeCount: SMPaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        controlCategory.layer.cornerRadius = controlCategory.frame.height / 2
        controlCategory.layer.masksToBounds = true        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}
