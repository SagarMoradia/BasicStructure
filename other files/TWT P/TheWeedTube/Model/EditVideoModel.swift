//
//  ModelRegistration.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 18/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct EditVideoModel : Decodable {
    let meta: Model_Meta?
    let data: vData?
    let errors : Model_Errors?
}

struct vData :Decodable,Encodable{
    let uuid:String?
}
