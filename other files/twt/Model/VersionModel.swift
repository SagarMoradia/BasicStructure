//
//  VersionModel.swift
//  Capchur
//
//  Created by Hitesh Surani on 26/10/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation

struct VersionModel:Decodable {
    let meta: Model_Meta
    let data : VersionData?
}

struct VersionData:Decodable {
    let force_update: String?
}
