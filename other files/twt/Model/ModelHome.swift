//
//  File.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelHome {
    let type:String?
    let videoList:[HomeData]?
    let footerAdsUrl:String?
}

struct HomeData{
    let videoID:String?
    let videoTitle:String?
    let videoThumbImage:String?
    let videoImage:String?
    //    let videoPlayURL:String?
    let videoViewes:String?
    let videoUploadTime:String?
    //    let videoQuality:String?
    let videoDuration:String?
    //    let videoShareURL:String?
    //    let videoVisibility:String?
    //    let videoVote:String?
    //    let videoAuthorSubscribed:String?
    let videoAuthorImage:String?
    let videoAuthorName:String?
    //    let videoAuthorBio:String?
    //    let videoAuthorSubscriberText:String?
}
