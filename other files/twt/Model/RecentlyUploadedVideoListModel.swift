//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct RecentlyUploadedVideoList_Model : Decodable {
    let meta: Model_Meta?
    let data: recentlyUploadedVideoData?
    let errors : Model_Errors?
}

struct recentlyUploadedVideoData :Decodable,Encodable{
    let headers: headerData?
    let original: recentlyUploadedVideoDataDict?
    let exception: exceptionData?
}

struct recentlyUploadedVideoDataDict :Decodable,Encodable{
    let draw:Int?
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let data:[recentlyUploadedVideoDataAry]?
}

struct recentlyUploadedVideoDataAry :Decodable,Encodable{
    let video_uuid:String?
    let title:String?
    let mediaid:String?
    let views:String?
    let date:String?
    let description:String?
    let duration:String?
    let slug:String?
    let user_uuid:String?
    let video_author_profile_pic:String?
    let link:String?
    let video_author_name:String?
    let video_auto_play:String?
    let image:String?
    let user_name:String?
    
    /*
     "video_uuid": "c2811230-ee23-4d0e-8598-acf8659ec1bb",
     "title": "Video title by Hasya",
     "mediaid": "jLsr7dWI",
     "views": "0",
     "date": "18 hours ago",
     "description": "Video description by Hasya",
     "duration": "17",
     "slug": "video-title-by-hasya-242",
     "user_uuid": "18",
     "video_author_profile_pic": "155194240118.jpg",
     "link": "https://cdn.jwplayer.com/previews/jLsr7dWI",
     "video_author_name": "Sweta Vani",
     "video_auto_play": "https://video.theweedtube.com/videos/jLsr7dWI.mp4",
     "image": "https://cdn.jwplayer.com/thumbs/jLsr7dWI-480.jpg"
    */
}
