//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct Model_CategoryVideoData : Decodable {
    let meta: Model_Meta?
    let data: [videoListData]?// videoData
    let errors : Model_Errors?
    let recordsTotal : Int?
}

//struct videoData :Decodable,Encodable{
//    let headers: headerData?
//    let original: videoDataDict?
//    let exception: exceptionData?
//}
//
//struct headerData :Decodable,Encodable{
//}
//struct exceptionData :Decodable,Encodable{
//}

//struct videoDataDict :Decodable,Encodable{
//    let draw:Int?
//    let recordsTotal:Int?
//    let recordsFiltered:Int?
//    let data:[videoListData]?
//}

struct videoListData :Decodable,Encodable{
    let id:Int?
    let uuid:String?
    let title:String?
    let slug:String?
    let jw_media_id:String?
    let category_id:String?
    let category_title:String?
    let thumbnail:String?
    let cover_photo:String?
    let duration:String?
    let status:String?
    let view_count:String?
    let publish_date:String?
    let today_view_count:String?
    let like_count:String?
    let dislike_count:String?
    let comment_count:String?
    let report_total_abuse:String?
    let ispublish:String?
    let created_at:String?
    let updated_at:String?
    let privacy:String?
    let user_id:Int?
    let user_name:String?
    let user_uuid : String?
    let user_image:String?
    let tags:[videoTags]?
    let video_auto_play:String?
    let video_preview:String?
    let description:String?
    let categories:[categories]?
    let thumbnail_480:String?
    
    let username:String?
    
    
    
    /*
     "id": "29",
     "uuid": "85d5b206-b97d-4765-91b5-b",
     "title": "xfgh 29",
     "slug": "xfgh-29",
     "jw_media_id": "",
     "category_id": "5",
     "category_title": "CBD life",
     "thumbnail": "https://cdn.jwplayer.com/thumbs/-120.jpg",
     "cover_photo": "",
     "duration": 0,
     "status": "Active",
     "view_count": 0,
     "publish_date": "",
     "today_view_count": 0,
     "like_count": 0,
     "dislike_count": 0,
     "comment_count": 0,
     "report_total_abuse": 0,
     "ispublish": "Yes",
     "created_at": "2019/02/27 13:26:43",
     "updated_at": "2019/02/27 13:26:43",
     "user_id": "44",
     "user_name": "urvish sabhaya new",
     */
}

struct videoTags :Decodable,Encodable{
    let id:Int?
    let tag:String?
    
    /*
     "tags": [
                 {
                     "id": "330",
                     "tag": "sgsv"
                 }
            ]
     */
}

struct categories :Decodable,Encodable{
    let category_id:String?
    let slug:String?
    let isFeature:String?
    let category_title:String?
    
    let name:String?
    
    //18Apr2019
    /*
    id = 5;
    name = Comedy;
    slug = comedy;
    */
    
    
    /*
     "categories": [
         {
             "category_id": 7,
             "slug": "technology",
             "isFeature": "Yes",
             "category_title": "Technology"
         }
     ]
     */
}
