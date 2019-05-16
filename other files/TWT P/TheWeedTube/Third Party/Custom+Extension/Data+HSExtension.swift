//
//  Data+Extension.swift
//  Capchur
//
//  Created by Hitesh Surani on 06/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation


extension Data {
    var contentType: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}

