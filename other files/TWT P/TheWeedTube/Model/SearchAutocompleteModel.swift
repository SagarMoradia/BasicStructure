//
//  File.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct Search_Autocomplete_Model : Decodable{
    let meta : Model_Meta?
    let data : [String]?
    let errors : Model_Errors?
}

struct SearchData :Decodable,Encodable{
    let videoID:String?
    let videoTitle:String?
}
