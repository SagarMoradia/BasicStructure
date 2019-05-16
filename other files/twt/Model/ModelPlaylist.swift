//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct Model_Playlist {
    var playlistName:String?
    var playlistDate:String?
    var playList:[Model_PlaylistData]?
    
    init(){
        playlistName = nil
        playlistDate = nil
        playList = nil
    }
}

struct Model_PlaylistData{
    var videoID:String?
    var videoThumbImageURL:String?
    
    init(){
        videoID = nil
        videoThumbImageURL = nil
    }
}
