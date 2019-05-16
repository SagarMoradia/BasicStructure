//
//  ModelNotification.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 18/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

//struct ModelNotification {
//    let title:String?
//    let videoAuthorImage:String?
//    let videoImage:String?
//    let notificationDate:String?
//    let isRead:Bool
//
//}


struct NotificationModel : Decodable {
    let meta: Model_Meta?
    let data: NotificationData?
    let errors : Model_Errors?
}

struct NotificationData :Decodable,Encodable{
    let headers: headerData?
    let original: NotificationDataDict?
    let exception: exceptionData?
}

struct NotificationDataDict :Decodable,Encodable{
    let draw:Int?
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let start:Int?
    let endOfRecord:Int?
    let data:[NotificationDataAry]?
}

struct NotificationDataAry :Decodable,Encodable{
    let _id:String?
    let user_name:String?
    let notifier_name:String?
    let ip_address:String?
    let notification_text:String?
    let notification_type:String?
    let component_id:String?
    let component_name:String?
    let created_by:String?
    let notifier_id:String?
    let user_id:String?
    let is_new:String?
    let isVisible:String?
    let turn_of_all_notification:String?
    let turn_of_for_post:String?
    let status:String?
    let created_at:String?
    let updated_at:String?
    let srNum:String?
    let uuid:String?
    let user_profile:String?
    let notifier_profile:String?
    let video_image:String?
    let video_image_thumb_120:String?

    let video_uuid:String?
    let user_uuid:String?

    
    /*
     {
         "_id": "5c8f270e3b458c446e3fcc82",
         "user_name": "Jai Raj",
         "notifier_name": "Jai Raj",
         "ip_address": "192.168.10.175",
         "notification_text": "Jai Raj commented on your post (Keyboard1)",
         "notification_type": "Comment",
         "component_id": "302",
         "component_name": "Video",
         "created_by": "19",
         "notifier_id": "19",
         "user_id": "19",
         "is_new": "1",
         "isVisible": "Yes",
         "turn_of_all_notification": "No",
         "turn_of_for_post": "No",
         "status": "Sent",
         "created_at": "9 hours ago",
         "updated_at": "9 hours ago",
         "srNum": "1",
         "uuid": "5c8f270e3b458c446e3fcc82",
         "user_profile": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/user/19/profile/",
         "notifier_profile": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/user/19/profile/",
         "video_image": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/video_thumbs/302/1552645508302.jpg",
         "video_image_thumb_120": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/video_thumbs/302/120x120/THUMB_120_1552645508302.jpg"
     }
     */
}
