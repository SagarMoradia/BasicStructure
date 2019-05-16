//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct Userlist_Model : Decodable {
    let meta: Model_Meta?
    let data: userlistData?
    let errors : Model_Errors?
}

struct userlistData :Decodable,Encodable{
    let headers: headerData?
    let original: userlistDataDict?
    let exception: exceptionData?
}

struct userlistDataDict :Decodable,Encodable{
    let draw:Int?
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let data:[userlistDataAry]?
}

class userlistDataAry :Decodable,Encodable{
    let uuid:String?
    let first_name:String?
    let last_name:String?
    let total_followers:String?
    let profile_image:String?
    var is_follow:String?
    
    let username:String?
    
    //For Followers List
    let users_uuid : String?
    let user_id : String?
    let full_name : String?
    let user_type : String?
    let total_following : String?
    let profile_image_100x100 : String?
    let profile_image_200x200 : String?
    
    
    /*
     "uuid": "15",
     "first_name": "vikash",
     "last_name": "MIshra",
     "total_followers": "2",
     "profile_image": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/user/15/155143529715.jpg",
     "is_follow": 0
     */
}
