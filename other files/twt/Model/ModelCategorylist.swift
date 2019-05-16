//
//  TheWeedTube
//
//  Created by Sandip Patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import Foundation

struct Model_CategoryData : Decodable {
    let meta: Model_Meta?
    let data: [categoryData]?
    let errors : Model_Errors?
}

struct categoryData :Decodable,Encodable{
    let id:Int?
    let uuid:String?
    let name:String?
    let logo:String?
    let total_videos:Int?
    let total_trends:Int?
    let slug:String?
    let logo_path:String?
}

struct updatedcategoryData :Decodable,Encodable{
    let id:Int?
    let uuid:String?
    let name:String?
    let logo:String?
    let total_videos:Int?
    let total_trends:Int?
    let slug:String?
    let logo_path:String?
    let isSelected:Bool?
}

//struct Model_CategoryData {
//
//    /*
//    "id": 5,
//    "name": "Health",
//    "logo": "15511771705.png",
//    "total_videos": 0,
//    "total_trends": 0,
//    "logo_path": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/category/5/15511771705.png"
//     */
//
//    var id:Int?
//    var name:String?
//    var logo:String?
//    var total_videos:Int?
//    var total_trends:Int?
//    var logo_path:String?
//
//
//    init(){
////        categoryName = "CBD Life"
////        videoCount = "250"
////        categoryThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Windrder2-web_bd5cb0f721881d106522f6b9cc8f5be6.jpg"
////        badgeCount = "5"
//    }
//}

