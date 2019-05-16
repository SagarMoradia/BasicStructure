//
//  CellMore.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellSideMenu: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewImageparent: UIView!
    
    var objMenuItem : MenuItem!{
        didSet {
            imgView?.image = objMenuItem.image
            lblName?.text = objMenuItem.title
            
            let isGuestUser = self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil ? false : true

            if objMenuItem.title.lowercased().contains("upload"){
                if !isGuestUser{
                    viewImageparent.backgroundColor = UIColor.init(hex: SideMenuHexColor.Background)
                    lblName.textColor = UIColor.init(hex: SideMenuHexColor.Background)
                }else{
                    viewImageparent.backgroundColor = UIColor.init(hex: SideMenuHexColor.BackgroundDisable)
                    lblName.textColor = UIColor.init(hex: SideMenuHexColor.TextDisable)
                }
            }else{
                viewImageparent.backgroundColor = UIColor.init(hex: SideMenuHexColor.BackgroundCircle)
                lblName.textColor = UIColor.init(hex: SideMenuHexColor.TextColor)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewImageparent.layer.cornerRadius = (sideMenuRowHeight * 0.6) / 2
        viewImageparent.layer.masksToBounds = true
        viewImageparent.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}
