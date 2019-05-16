// Doubt
//  VideoListCell.swift
//  TheWeedTube
//
//  Created by Vivek Bhoraniya on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class VideoListCell: CellHome {
    
    @IBOutlet weak var btnMoreVideo: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var imgViewVideo: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    
    var modelVideoData : Model_VideoData?{
        didSet {
            
            let title = modelVideoData?.title ?? ""
            self.lblTitle.text = title.stringByDecodingHTMLEntities
            
//            self.lblTitle.text = modelVideoData?.title?.HSDecode ?? ""
            
            self.lblDuration.text = self.timeFormatted(totalSeconds: modelVideoData?.duration ?? 0)
            
            loadImageWith(imgView: imgViewVideo, url: modelVideoData?.image, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            
//            let arrCat = modelVideoData?.category
//            if (arrCat?.count)! > 0{
//                let cat = arrCat![0]
//                self.lblCategory.text = cat.name ?? ""
//            }else{
//                self.lblCategory.text = ""
//            }
            
            self.lblCategory.text = modelVideoData?.user_name ?? ""
            
            let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(modelVideoData?.views ?? "0") ?? 0))
            self.lblViews.text = "\(totalViews) Views"
        }
    }
    
    var objModelPlaylistdata : playlistMainData!{
        didSet {
            
            self.lblTitle.text = objModelPlaylistdata?.title?.HSDecode ?? ""
            
            //Duration conversion
            let duration = objModelPlaylistdata?.duration ?? "0"
            let doubleDuration = Double(duration) ?? 0.0
            self.lblDuration.text = self.timeFormatted(totalSeconds: Int(doubleDuration)) //objModelPlaylistdata?.duration //
            
            loadImageWith(imgView: imgViewVideo, url: objModelPlaylistdata?.thumbnail, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            self.lblCategory.text = objModelPlaylistdata?.category_name ?? ""
//            let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelPlaylistdata?.view_count ?? "0") ?? 0))
//            self.lblViews.text = "\(totalViews) Views"

        }
    }
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
