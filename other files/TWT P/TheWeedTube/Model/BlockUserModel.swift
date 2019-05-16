//
//  LoginModel.swift
//  DELRentals
//
//  Created by Sweta Vani on 08/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation

struct BlockUserModel : Decodable {
    let meta: Model_Meta?
    let data: blockData?
    let errors : Model_Errors?
}

struct blockData :Decodable,Encodable{
    let is_block : String?
}
