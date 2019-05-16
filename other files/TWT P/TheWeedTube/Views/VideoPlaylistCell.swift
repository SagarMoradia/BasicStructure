//
//  VideoPlaylistCell.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 25/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class VideoPlaylistCell: CellHome {

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
