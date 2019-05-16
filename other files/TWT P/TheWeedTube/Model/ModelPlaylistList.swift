//
//  ModelPlaylistList.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 25/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelPlaylistList : Decodable {
    let meta: Model_Meta?
    let data: ModelPlaylistData?
    let errors : Model_Errors?
}

struct ModelPlaylistData : Codable {
    let headers : Headers?
    let original : playlistOriginal?
    let exception : String?
    let playlistInfo : PlaylistInfo?
    
    enum CodingKeys: String, CodingKey {
        
        case headers = "headers"
        case original = "original"
        case exception = "exception"
        case playlistInfo = "playlistInfo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        headers = try values.decodeIfPresent(Headers.self, forKey: .headers)
        original = try values.decodeIfPresent(playlistOriginal.self, forKey: .original)
        exception = try values.decodeIfPresent(String.self, forKey: .exception)
        playlistInfo = try values.decodeIfPresent(PlaylistInfo.self, forKey: .playlistInfo)
    }
    
}

struct playlistOriginal : Codable {
    let draw : Int?
    let recordsTotal : Int?
    let recordsFiltered : Int?
    let data : [playlistMainData]?
    
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
        data = try values.decodeIfPresent([playlistMainData].self, forKey: .data)
    }
    
}

struct playlistMainData : Decodable,Encodable {
    let uuid : String?
    let updated_at : String?
    let privacy : String?
    let slug : String?
    let id : String?
    let wp_id : String?
    let title : String?
    let jw_media_id : String?
    let category_id : String?
    let channel_id : Int?
    let thumbnail : String?
    let cover_photo : String?
    let type : String?
    let duration : String?
    let status : String?
    let description : String?
    let publish_date : String?
    let view_count : String?
    let today_view_count : String?
    let like_count : String?
    let dislike_count : String?
    let comment_count : String?
    let report_total_abuse : String?
    let ispublish : String?
    let isBroadcast : String?
    let updated_by : String?
    let created_by : String?
    let created_at : String?
    let deleted_at : String?
    let today_view_count_date : String?
    let user_id : String?
    let user_name : String?
    let user_image : String?
    let video_auto_play : String?
    let video_preview : String?
    let srNum : String?
    let category_name:String?
    let thumbnail_480:String?

}

struct PlaylistInfo : Codable {
    let id : Int?
    let uuid : String?
    let name : String?
    let privacy : String?
    let total_videos : String?
    let slug : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case uuid = "uuid"
        case name = "name"
        case privacy = "privacy"
        case total_videos = "total_videos"
        case slug = "slug"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        total_videos = try values.decodeIfPresent(String.self, forKey: .total_videos)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
    }
    
}
