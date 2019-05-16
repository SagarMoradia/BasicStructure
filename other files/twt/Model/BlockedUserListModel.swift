//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct BlockedUserListModel : Decodable {
    let meta: Model_Meta?
    let data: BlockedUserlistData?
    let errors : Model_Errors?
}

struct BlockedUserlistData :Decodable,Encodable{
    let headers: headerData?
    let original: BlockedUserlistDataDict?
    let exception: exceptionData?
}

struct BlockedUserlistDataDict :Decodable,Encodable{
    let draw:Int?
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let data:[BlockedUserlistDataAry]?
}

class BlockedUserlistDataAry :Decodable,Encodable{
    let uuid:String?
    let first_name:String?
    let last_name:String?
    let total_followers:String?
    let profile_image:String?
    var is_follow:String?
    let username:String?
    let created_at : String?
    
    /*
   
     "uuid": "64e950d4-5f7b-11e9-8e3e-000c29f57809",
     "first_name": "Xia",
     "last_name": "Skowronek",
     "total_followers": "20",
     "profile_image": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/user/48287/profile/thumbnails/200x200/THUMB_200_5c645e565ea89-bpfull.jpg",
     "username": "casuallystoned",
     "created_at": "2019-01-08 15:49:14",
     "is_follow": "No"
     
     */
}
