//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct Playlist_Model : Decodable {
    let meta: Model_Meta?
    let data: playlistData?
    let errors : Model_Errors?
}

struct playlistData :Decodable,Encodable{
    let headers: headerData?
    let original: playlistDataDict?
    let exception: exceptionData?
}

struct headerData :Decodable,Encodable{
}
struct exceptionData :Decodable,Encodable{
}

struct playlistDataDict :Decodable,Encodable{
    let draw:Int?
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let data:[playlistDataAry]?
}

struct playlistDataAry :Decodable,Encodable{
    let uuid:String?
    let name:String?
    let total_videos:String?
    let updated_at:String?
    let privacy:String?
    let media_image:[String]?
    let first_video_details:first_video_details?
    
    /*
     "uuid": "2",
     "name": "sportss",
     "total_videos": "2",
     "updated_at": "2019-02-27 10:06:39",
     "privacy": "1",
     "media_image": [
             "https://cdn.jwplayer.com/thumbs/yZtPlx50-120.jpg",
             "https://cdn.jwplayer.com/thumbs/YbmruMSN-120.jpg",
             "https://cdn.jwplayer.com/thumbs/y9QAEI0w-120.jpg"
        ]
     */
}

struct first_video_details :Decodable,Encodable {
    let uuid : String?
    let slug : String?
}
