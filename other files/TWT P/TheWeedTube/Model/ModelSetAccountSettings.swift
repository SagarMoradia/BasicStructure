//
//  ModelSetAccountSettings.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 20/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelSetAccountSettings : Decodable {
    let meta: Model_Meta?
    let data: [AccountData]?
    let errors : Model_Errors?
}

struct AccountData :Decodable,Encodable{
    
    
}
