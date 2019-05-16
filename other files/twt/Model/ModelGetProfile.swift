//
//  ModelGetProfile.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 21/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelGetProfile : Decodable {
    let meta: Model_Meta?
    let data: ProfileData?
    let errors : Model_Errors?
}

struct ProfileData : Codable {
    let user_data : User_data?
    
}

struct User_data : Codable {
    let id : Int?
    let username : String?
    let email : String?
    let profile_image : String?
    let cover_image : String?
    let first_name : String?
    let last_name : String?
    let date_of_birth : String?
    let about_me : String?
    let social_accounts : [Social_accounts]?
    let profile_photo : String?
    let cover_photo : String?
    let total_followers : Int?
    let joined_date : String?
    let total_profile_views : Int?
    let is_follow : String?
    let is_block : String?
    
    let subscribe_newsletter : String?
    let notification_count : Int?
    let notification_unread_count : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case username = "username"
        case email = "email"
        case profile_image = "profile_image"
        case cover_image = "cover_image"
        case first_name = "first_name"
        case last_name = "last_name"
        case date_of_birth = "date_of_birth"
        case about_me = "about_me"
        case social_accounts = "social_accounts"
        case profile_photo = "profile_photo"
        case cover_photo = "cover_photo"
        case total_followers = "total_followers"
        case joined_date = "joined_date"
        case total_profile_views = "total_profile_views"
        case is_follow = "is_follow"
        case is_block = "is_block"
        
        case subscribe_newsletter = "subscribe_newsletter"
        case notification_count = "notification_count"
        case notification_unread_count = "notification_unread_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        cover_image = try values.decodeIfPresent(String.self, forKey: .cover_image)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        date_of_birth = try values.decodeIfPresent(String.self, forKey: .date_of_birth)
        about_me = try values.decodeIfPresent(String.self, forKey: .about_me)
        social_accounts = try values.decodeIfPresent([Social_accounts].self, forKey: .social_accounts)
        profile_photo = try values.decodeIfPresent(String.self, forKey: .profile_photo)
        cover_photo = try values.decodeIfPresent(String.self, forKey: .cover_photo)
        total_followers = try values.decodeIfPresent(Int.self, forKey: .total_followers)
        joined_date = try values.decodeIfPresent(String.self, forKey: .joined_date)
        total_profile_views = try values.decodeIfPresent(Int.self, forKey: .total_profile_views)
        is_follow = try values.decodeIfPresent(String.self, forKey: .is_follow)
        
        is_block = try values.decodeIfPresent(String.self, forKey: .is_block)
        
        subscribe_newsletter = try values.decodeIfPresent(String.self, forKey: .subscribe_newsletter)
        notification_count = try values.decodeIfPresent(Int.self, forKey: .notification_count)
        notification_unread_count = try values.decodeIfPresent(Int.self, forKey: .notification_unread_count)
        
    }
    
}


struct Social_accounts : Codable {
    let social_media_name : String?
    var social_media_url : String?
    
    enum CodingKeys: String, CodingKey {
        
        case social_media_name = "social_media_name"
        case social_media_url = "social_media_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        social_media_name = try values.decodeIfPresent(String.self, forKey: .social_media_name)
        social_media_url = try values.decodeIfPresent(String.self, forKey: .social_media_url)
    }
}

class classSocial {
    let social_media_name : String!
    var social_media_url : String!
    var imgIcon : String!
    
    init(objSocial_accounts:Social_accounts) {
        self.social_media_name = objSocial_accounts.social_media_name
        self.social_media_url = objSocial_accounts.social_media_url
        self.imgIcon = objSocial_accounts.social_media_url?.count ?? 0 == 0 ?  self.social_media_name : self.social_media_name + "_h" 
    }
    
    init(dictValue:[String:String]) {
        self.social_media_name = dictValue["name"]
        self.social_media_url = ""
        self.imgIcon = dictValue["name"]!.lowercased()
    }
}
