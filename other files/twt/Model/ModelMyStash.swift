//
//  ModelMyStash.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 05/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelMyStash : Decodable {
    let meta: Model_Meta?
    let data: MyStashData?
    let errors : Model_Errors?
}

struct MyStashData : Codable {
    let headers : Headers?
    let original : Original?
    let exception : String?
    
    enum CodingKeys: String, CodingKey {
        
        case headers = "headers"
        case original = "original"
        case exception = "exception"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        headers = try values.decodeIfPresent(Headers.self, forKey: .headers)
        original = try values.decodeIfPresent(Original.self, forKey: .original)
        exception = try values.decodeIfPresent(String.self, forKey: .exception)
    }
    
}

struct Headers : Codable {
    

    
}

struct Original : Codable {
    let draw : Int?
    let recordsTotal : Int?
    let recordsFiltered : Int?
    let data : [statshData]?
    
    enum CodingKeys: String, CodingKey {
        
        case draw = "draw"
        case recordsTotal = "recordsTotal"
        case recordsFiltered = "recordsFiltered"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        draw = try values.decodeIfPresent(Int.self, forKey: .draw)
        recordsTotal = try values.decodeIfPresent(Int.self, forKey: .recordsTotal)
        recordsFiltered = try values.decodeIfPresent(Int.self, forKey: .recordsFiltered)
        data = try values.decodeIfPresent([statshData].self, forKey: .data)
    }
    
}

struct statshData : Codable {
    let video_id : String?
    let uuid : String?
    let title : String?
    let slug : String?
    let jw_media_id : String?
    let id : String?
    let name : String?
    let thumbnail : String?
    let cover_photo : String?
    let duration : String?
    let status : String?
    let privacy : String?
    let view_count : String?
    let publish_date : String?
    let today_view_count : String?
    let like_count : String?
    let dislike_count : String?
    let comment_count : String?
    let report_total_abuse : String?
    let ispublish : String?
    let user_name : String?
    let tags : [Tags]?
    let user_profile_image : String?
    let video_auto_play : String?
    let video_preview : String?
    let visitors_uuid : String?
    let thumbnail_480 : String?
    
    let username : String?
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case video_id = "video_id"
        case uuid = "uuid"
        case title = "title"
        case slug = "slug"
        case jw_media_id = "jw_media_id"
        case id = "id"
        case name = "name"
        case thumbnail = "thumbnail"
        case cover_photo = "cover_photo"
        case duration = "duration"
        case status = "status"
        case privacy = "privacy"
        case view_count = "view_count"
        case publish_date = "publish_date"
        case today_view_count = "today_view_count"
        case like_count = "like_count"
        case dislike_count = "dislike_count"
        case comment_count = "comment_count"
        case report_total_abuse = "report_total_abuse"
        case ispublish = "ispublish"
        case user_name = "user_name"
        case tags = "tags"
        case user_profile_image = "user_profile_image"
        case video_auto_play = "video_auto_play"
        case video_preview = "video_preview"
        case visitors_uuid = "visitors_uuid"
        case thumbnail_480 = "thumbnail_480"
       
         case username = "username"
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        video_id = try values.decodeIfPresent(String.self, forKey: .video_id)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        jw_media_id = try values.decodeIfPresent(String.self, forKey: .jw_media_id)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        cover_photo = try values.decodeIfPresent(String.self, forKey: .cover_photo)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        view_count = try values.decodeIfPresent(String.self, forKey: .view_count)
        publish_date = try values.decodeIfPresent(String.self, forKey: .publish_date)
        today_view_count = try values.decodeIfPresent(String.self, forKey: .today_view_count)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        dislike_count = try values.decodeIfPresent(String.self, forKey: .dislike_count)
        ispublish = try values.decodeIfPresent(String.self, forKey: .ispublish)
        report_total_abuse = try values.decodeIfPresent(String.self, forKey: .report_total_abuse)
        comment_count = try values.decodeIfPresent(String.self, forKey: .comment_count)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        tags = try values.decodeIfPresent([Tags].self, forKey: .tags)
        user_profile_image = try values.decodeIfPresent(String.self, forKey: .user_profile_image)
        video_auto_play = try values.decodeIfPresent(String.self, forKey: .video_auto_play)
        video_preview = try values.decodeIfPresent(String.self, forKey: .video_preview)
        visitors_uuid = try values.decodeIfPresent(String.self, forKey: .visitors_uuid)
        thumbnail_480 = try values.decodeIfPresent(String.self, forKey: .thumbnail_480)
        
        username = try values.decodeIfPresent(String.self, forKey: .username)
        
    }
    
}

struct Tags : Codable {
    let id : String?
    let tag : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case tag = "tag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        tag = try values.decodeIfPresent(String.self, forKey: .tag)
    }
    
}
