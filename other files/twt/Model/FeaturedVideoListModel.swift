//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct FeaturedVideoListModel : Decodable {
    let meta: Model_Meta?
    let data: featuredVideoData?
    let errors : Model_Errors?
}

struct featuredVideoData :Decodable,Encodable{
    let headers: headerData?
    let original: featuerdVideoDataDict?
    let exception: exceptionData?
}

struct featuerdVideoDataDict :Decodable,Encodable{
    let draw:Int?
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let data:[featuerdVideoDataAry]?
}

struct featuerdVideoDataAry :Decodable,Encodable{
    let id:String?
    let uuid:String?
    let title:String?
    let slug:String?
    let jw_media_id:String?
    let thumbnail:String?
    let duration:String?
    let status:String?
    let description:String?
    let publish_date:String?
    let view_count:String?
    let today_view_count:String?
    let user_uuid:String?
    let user_id:String?
    let user_name:String?
    let user_image:String?
    //let category:[CategoryData]?
    let link:String?
    let video_auto_play:String?
    let recommendations:String?

    /*
     {
         "id": "302",
         "uuid": "164f3037-accd-4f29-bd3a-948b9f26b496",
         "title": "Keyboard1",
         "slug": "keyboard1-302",
         "jw_media_id": "I2nZl6oF",
         "thumbnail": "https://cdn.jwplayer.com/thumbs/I2nZl6oF-720.jpg",
         "duration": "0",
         "status": "Active",
         "description": "keys",
         "publish_date": "41 minutes ago",
         "view_count": "0",
         "today_view_count": "0",
         "user_uuid": "19",
         "user_id": "19",
         "user_name": "iMHites",
         "user_image": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/user/19/profile/",
         "category": [
                     {
                     "id": "7",
                     "name": "Technology"
                     }
         ],
         "link": "https://cdn.jwplayer.com/previews/I2nZl6oF",
         "video_auto_play": "https://video.theweedtube.com/videos/I2nZl6oF.mp4",
         "recommendations": "https://cdn.jwplayer.com/v2/playlists/a2SJ62ct?related_media_id=I2nZl6oF"
     }
    */
}

