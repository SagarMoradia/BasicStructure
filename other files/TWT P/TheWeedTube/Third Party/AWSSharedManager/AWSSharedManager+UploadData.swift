//
//  AWSSharedManager+UploadData.swift
//  Capchur
//
//  Created by Hitesh Surani on 06/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation
import AWSS3
import AWSSES

extension AWSSharedManager{
    
    //MARK:Upload Images/Videos in Data form
    func uploadDataToAWS(data: [UploadAWS],completion:AWSHandler,progress:AWSProgressHandler) {
        
        completionGlobal = completion
        progressGlobal = progress
        
//        aryAllRecord = data
        
        var counttaskID = 0
        for objAwsUpload in data{
            
            let imageKey = objAwsUpload.url
            let dataToUpload = objAwsUpload.data
            
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.customID = counttaskID
            
            var progressBlock: AWSS3TransferUtilityProgressBlock?
            
            //MARK:Task progress for each file
            progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {
                    
                    let progress = Float(progress.fractionCompleted)// * 100
                    objAwsUpload.progress = progress
                    
                    let totalSize = Float(dataToUpload.count)
                    let fileUplodedSize = totalSize*progress
                    
                    let strTotalSizeUploaded = GLOBAL.sharedInstance.fileSize(fileSize:fileUplodedSize)!
                    let strTotalSize = GLOBAL.sharedInstance.fileSize(fileSize:totalSize)!
                    
                    objAwsUpload.completion = "\(strTotalSizeUploaded)/\(strTotalSize)"
//                    print(Double(dataToUpload.count)/1024.0)
                    
                    //0 KB/0 MB
                    //dataToUpload.count*progress / dataToUpload.count
                    self.progressGlobal!!(data,expression.customID)
                })
            }
            
            expression.progressBlock = progressBlock
            
            let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            
            //MARK:Task Completed
            completionHandler = { (task, error) -> Void in
                DispatchQueue.main.async(execute: {
                    if let error = error {
                        print("Failed with error: \(error)")
                        self.completionGlobal!!(false,expression.customID,"")
                    }
                    else{
                        let objUploadAWS = data[expression.customID]
                        objUploadAWS.status = Cons_Complete
                        print(expression.customID,AWSConstant.AWS_KEY_URL_FILE+imageKey)
                        self.completionGlobal!!(true,expression.customID,AWSConstant.AWS_KEY_URL_FILE+imageKey)
                    }
                })
            }
            
            
            
            let taskImage = transferUtility.uploadData(
                dataToUpload,
                bucket: AWSConstant.AWS_BUCKET_NAME,
                key: imageKey,
                contentType: imageKey.components(separatedBy:".").last!,
                expression: expression,
                completionHandler: completionHandler)
            
            taskImage.continueWith { (task) -> AnyObject! in
                
                print(expression.customID)
                
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion!(false,expression.customID,"")
                    }
                }
                return nil;
            }
            counttaskID = counttaskID + 1
        }
    }
}
