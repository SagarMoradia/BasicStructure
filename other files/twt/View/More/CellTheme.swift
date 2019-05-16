//
//  CellTheme.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellTheme: UITableViewCell {
    
    @IBOutlet weak var lblName : blackLabelCtrlModel!
    @IBOutlet weak var cntrlSwitch : PVSwitch!

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
