//
//  ModelFeedList.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 29/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelFeedList : Decodable {
    let meta: Model_Meta?
    let data: [FeedData]?
    let errors : Model_Errors?
    let recordsTotal : Int?
}

struct FeedData : Codable {
    let id : Int?
    let uuid : String?
    let title : String?
    let slug : String?
    let jw_media_id : String?
    let categories : [Categories]?
    let thumbnail : String?
    let cover_photo : String?
    let duration : String?
    let status : String?
    let view_count : String?
    let publish_date : String?
    let today_view_count : String?
    let like_count : String?
    let dislike_count : String?
    let comment_count : String?
    let report_total_abuse : String?
    let ispublish : String?
    let privacy : String?
    let created_at : String?
    let updated_at : String?
    let user_id : Int?
    let user_uuid : String?
    let user_name : String?
    let username : String?
    let user_image : String?
    let tags : [feedTags]?
    let description : String?
    let videoName : String?
    let video_auto_play : String?
    let video_preview : String?
    let thumbnail_480 : String?
    
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case uuid = "uuid"
        case title = "title"
        case slug = "slug"
        case jw_media_id = "jw_media_id"
        case categories = "categories"
        case thumbnail = "thumbnail"
        case cover_photo = "cover_photo"
        case duration = "duration"
        case status = "status"
        case view_count = "view_count"
        case publish_date = "publish_date"
        case today_view_count = "today_view_count"
        case like_count = "like_count"
        case dislike_count = "dislike_count"
        case comment_count = "comment_count"
        case report_total_abuse = "report_total_abuse"
        case ispublish = "ispublish"
        case privacy = "privacy"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case user_id = "user_id"
        case user_uuid = "user_uuid"
        case user_name = "user_name"
        case username = "username"
        case user_image = "user_image"
        case tags = "tags"
        case description = "description"
        case videoName = "videoName"
        case video_auto_play = "video_auto_play"
        case video_preview = "video_preview"
        case thumbnail_480 = "thumbnail_480"
        
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        jw_media_id = try values.decodeIfPresent(String.self, forKey: .jw_media_id)
        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        cover_photo = try values.decodeIfPresent(String.self, forKey: .cover_photo)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        view_count = try values.decodeIfPresent(String.self, forKey: .view_count)
        publish_date = try values.decodeIfPresent(String.self, forKey: .publish_date)
        today_view_count = try values.decodeIfPresent(String.self, forKey: .today_view_count)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        dislike_count = try values.decodeIfPresent(String.self, forKey: .dislike_count)
        comment_count = try values.decodeIfPresent(String.self, forKey: .comment_count)
        report_total_abuse = try values.decodeIfPresent(String.self, forKey: .report_total_abuse)
        ispublish = try values.decodeIfPresent(String.self, forKey: .ispublish)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        user_uuid = try values.decodeIfPresent(String.self, forKey: .user_uuid)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        tags = try values.decodeIfPresent([feedTags].self, forKey: .tags)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        videoName = try values.decodeIfPresent(String.self, forKey: .videoName)
        video_auto_play = try values.decodeIfPresent(String.self, forKey: .video_auto_play)
        video_preview = try values.decodeIfPresent(String.self, forKey: .video_preview)
        thumbnail_480 = try values.decodeIfPresent(String.self, forKey: .thumbnail_480)
       
    
        
        
        
    }
    
}

struct Categories : Codable {
    let category_title : String?
    let category_id : String?
    let is_feature : String?
    let slug : String?
    
    enum CodingKeys: String, CodingKey {
        
        case category_title = "category_title"
        case category_id = "category_id"
        case is_feature = "is_feature"
        case slug = "slug"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category_title = try values.decodeIfPresent(String.self, forKey: .category_title)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        is_feature = try values.decodeIfPresent(String.self, forKey: .is_feature)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
    }
    
}

struct feedTags : Codable {
    let id : Int?
    let tag : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case tag = "tag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        tag = try values.decodeIfPresent(String.self, forKey: .tag)
    }
    
}
