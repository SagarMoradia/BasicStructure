//
//  LoginModel.swift
//  DELRentals
//
//  Created by Sweta Vani on 08/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation

struct LoginModel : Decodable {
    let meta: Model_Meta?
    let data: userData?
    let errors : Model_Errors?
}

struct userData :Decodable,Encodable{
    let token_type : String?
    let expires_in : Int?
    let access_token : String
    let refresh_token : String?
    let user_detail : User_Detail?
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token_type, forKey:.token_type)
        try container.encode(expires_in, forKey:.expires_in)
        try container.encode(access_token, forKey:.access_token)
        try container.encode(refresh_token, forKey:.refresh_token)
        try container.encode(user_detail, forKey:.user_detail)
    }
    
}

class User_Detail : Decodable,Encodable{
    
    var username : String?
    var email : String?
    var role : String?
    var profile_image : String?
    var first_name : String?
    var last_name : String?
    var profile_photo : String?
    var uuid : String?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey:.username)
        try container.encode(email, forKey:.email)
        try container.encode(role, forKey:.role)
        try container.encode(profile_image, forKey:.profile_image)
        try container.encode(profile_photo, forKey:.profile_photo)
        try container.encode(first_name, forKey:.first_name)
        try container.encode(last_name, forKey:.last_name)
        try container.encode(uuid, forKey:.uuid)
    }
}


struct ModelCommonResponse : Decodable {
    let meta: Model_Meta?
    let errors : Model_Errors?
}
