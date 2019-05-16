//
//  CellComments.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 12/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellComments: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
         selectionStyle = .none
    }
    
}
