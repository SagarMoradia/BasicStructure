//
//  ModelRegistration.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 18/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct DeleteVideoModel : Decodable {
    let meta: Model_Meta?
    let data: deleteData?
    let errors : Model_Errors?
}

struct deleteData :Decodable,Encodable{
}
