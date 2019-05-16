//
//  CellMore.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellMore: UITableViewCell {
    
    @IBOutlet weak var lblName: blackLabelCtrlModel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBadge: UIView!
    @IBOutlet weak var lblCount: yellowLabelCtrlModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewTop.layer.cornerRadius = viewTop.frame.height/2
        viewTop.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
}
