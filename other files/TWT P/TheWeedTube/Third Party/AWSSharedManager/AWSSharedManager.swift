//
//  AWSSharedManager.swift
//  Capchur
//
//  Created by Shweta Vani on 05/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import UIKit
import AWSS3
import AWSSES

typealias AWSHandler = ((_ status:Bool,_ taskID:Int,_ fileurl:String)->())?
typealias AWSProgressHandler = (( _ progress:[UploadAWS],_ taskID:Int)->())?

class AWSSharedManager: NSObject {

    var aryAllRecord:[UploadAWS]!
    let transferUtility = AWSS3TransferUtility.default()

    static let shared: AWSSharedManager = AWSSharedManager()
    
  
    //MARK: Global Block
    var completionGlobal:AWSHandler!
    var progressGlobal:AWSProgressHandler!
    
}

