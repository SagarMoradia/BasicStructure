//
//  AWSModel.swift
//  Capchur
//
//  Created by Hitesh Surani on 21/07/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation


class UploadAWS {
    var url:String
    var imageToUpload:UIImage
    var name:String
    var data:Data
    var progress:Float
    var completion:String
    var status:String
    var type:String = "Image"
    var isPrimary:String = "0"

    
    init(imageToUpload:UIImage,url:String,name:String,data:Data,progress:Float,completion:String,status:String) {
        self.imageToUpload = imageToUpload
        self.url = url
        self.name = name
        self.data = data
        self.progress = progress
        self.status = status
        self.completion = completion
    }
    
    init(imageToUpload:UIImage,url:String,name:String,data:Data,progress:Float,completion:String,status:String,type:String) {
        self.imageToUpload = imageToUpload
        self.url = url
        self.name = name
        self.data = data
        self.progress = progress
        self.status = status
        self.completion = completion
        self.type = type
    }
}
