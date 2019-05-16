//
//  ModelAccountSettings.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 20/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

struct ModelAccountSettings : Decodable {
    let meta: Model_Meta?
    let data: AccountSettingsData?
    let errors : Model_Errors?
}

struct AccountSettingsData : Codable {
    let gENERAL : [GENERAL]?
    let aCTIVITY : [GENERAL]?
    
    enum CodingKeys: String, CodingKey {
        
        case gENERAL = "GENERAL"
        case aCTIVITY = "ACTIVITY"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gENERAL = try values.decodeIfPresent([GENERAL].self, forKey: .gENERAL)
        aCTIVITY = try values.decodeIfPresent([GENERAL].self, forKey: .aCTIVITY)
    }
    
}

struct GENERAL : Codable {
    var id : Int?
    let name : String?
    let type : String?
    let read : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case type = "type"
        case read = "read"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        read = try values.decodeIfPresent(String.self, forKey: .read)
    }
    
}


class ClassAccountSettings{
    let id : String
    let name : String
    let type : String
    var isEnable : Bool
    
    init(objGENERAL:GENERAL) {
        self.id = String(objGENERAL.id ?? 0)
        self.name = objGENERAL.name ?? ""
        self.type = objGENERAL.type ?? ""
        
        if objGENERAL.read ?? "false" == "false"{
            self.isEnable = false
        }else{
            self.isEnable = true
        }
    }
}
