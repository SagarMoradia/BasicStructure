//
//  CellPlaylist.swift
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class CellPlaylist: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUpdatedDate: UILabel!
    @IBOutlet weak var imageViewThumb1: UIImageView!
    @IBOutlet weak var imageViewThumb2: UIImageView!
    @IBOutlet weak var imageViewThumb3: UIImageView!
    @IBOutlet weak var imageViewPlayIcon: UIImageView!
    @IBOutlet weak var imageViewShadow: UIImageView!
    @IBOutlet weak var lblMoreMediaCount: UILabel!

    
    var objModelPlaylist : Model_Playlist!{
        didSet {
            
//            loadImageWith(imgView: imageViewThumb1, url: objModelPlaylist.videoImage)
//            lblTitle.text = objModelPlaylist.videoTitle
            
            let mediaCount = (objModelPlaylist.playList?.count)!
            
            lblTitle.text = objModelPlaylist.playlistName?.HSDecode ?? ""
            lblUpdatedDate.text = objModelPlaylist.playlistDate ?? ""
            
            if(mediaCount >= 3){                
                let mediaURL1 = objModelPlaylist.playList![0].videoThumbImageURL ?? ""
                self.loadImageWith(imgView: imageViewThumb1, url: mediaURL1, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                let mediaURL2 = objModelPlaylist.playList![1].videoThumbImageURL ?? ""
                self.loadImageWith(imgView: imageViewThumb2, url: mediaURL2, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                let mediaURL3 = objModelPlaylist.playList![2].videoThumbImageURL ?? ""
                self.loadImageWith(imgView: imageViewThumb3, url: mediaURL3, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                if(mediaCount > 3){
                    imageViewPlayIcon.isHidden = false
                    lblMoreMediaCount.isHidden = false
                    imageViewShadow.isHidden = false
                    lblMoreMediaCount.text = "\(mediaCount - 3)"
                }
                else{
                    imageViewPlayIcon.isHidden = true
                    lblMoreMediaCount.isHidden = true
                    imageViewShadow.isHidden = true
                }
            }
            else if(mediaCount == 2){
                let mediaURL1 = objModelPlaylist.playList![0].videoThumbImageURL ?? ""
                self.loadImageWith(imgView: imageViewThumb1, url: mediaURL1, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                let mediaURL2 = objModelPlaylist.playList![1].videoThumbImageURL ?? ""
                self.loadImageWith(imgView: imageViewThumb2, url: mediaURL2, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            }
            else if(mediaCount == 1){
                let mediaURL1 = objModelPlaylist.playList![0].videoThumbImageURL ?? ""
                self.loadImageWith(imgView: imageViewThumb1, url: mediaURL1, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            }
        }
    }
    
    var objModelPlaylistNew : playlistDataAry!{
        didSet {
            
            let mediaCount = (objModelPlaylistNew.media_image?.count)!
            
            lblTitle.text = objModelPlaylistNew.name?.HSDecode ?? ""
            lblUpdatedDate.text = objModelPlaylistNew.updated_at ?? ""
            
            if(mediaCount >= 3){
                let mediaURL1 = objModelPlaylistNew.media_image![0]
                self.loadImageWith(imgView: imageViewThumb1, url: mediaURL1, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                let mediaURL2 = objModelPlaylistNew.media_image![1]
                self.loadImageWith(imgView: imageViewThumb2, url: mediaURL2, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                let mediaURL3 = objModelPlaylistNew.media_image![2]
                self.loadImageWith(imgView: imageViewThumb3, url: mediaURL3, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                if(mediaCount > 3){
                    imageViewPlayIcon.isHidden = false
                    lblMoreMediaCount.isHidden = false
                    imageViewShadow.isHidden = false
                    lblMoreMediaCount.text = "\(mediaCount - 3)"
                }
                else{
                    imageViewPlayIcon.isHidden = true
                    lblMoreMediaCount.isHidden = true
                    imageViewShadow.isHidden = true
                }
            }
            else if(mediaCount == 2){
                let mediaURL1 = objModelPlaylistNew.media_image![0]
                self.loadImageWith(imgView: imageViewThumb1, url: mediaURL1, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
                
                let mediaURL2 = objModelPlaylistNew.media_image![1]
                self.loadImageWith(imgView: imageViewThumb2, url: mediaURL2, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            }
            else if(mediaCount == 1){
                let mediaURL1 = objModelPlaylistNew.media_image![0]
                self.loadImageWith(imgView: imageViewThumb1, url: mediaURL1, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}
