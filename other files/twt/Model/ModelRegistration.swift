//
//  ModelRegistration.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 18/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelRegistration : Decodable {
    let meta: Model_Meta?
    let data: registerData?
    let errors : Model_Errors?
}

struct registerData :Decodable,Encodable{
    let uuid:String?
}
