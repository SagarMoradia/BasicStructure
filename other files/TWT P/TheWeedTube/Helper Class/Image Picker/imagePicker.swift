//
//  Extension.swift
//  SilverTouchPractical
//
//  Created by Hitesh Surani on 17/02/18.
//  Copyright © 2018 HItesh. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

struct Picker_Alert {
    static let app_name = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let alert_title = "Permission Denied"
    static let alert_description = "Please \(app_name) to access your photos from Setting"
    static let btn_title = "Setting"
    
    //Video Record Duration
    static let video_duration = 1200 //20 min
}

typealias ImageCompletionHandler = ((_ image:UIImage?,_ url:URL?,_ status:Bool)->())?


class imagePicker:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var previousNumber: Int?
    
//    let topVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
    
    let imagePickerControll:UIImagePickerController = UIImagePickerController()
    
    var imageHandler:ImageCompletionHandler!
    
    static let sharedInstance : imagePicker = imagePicker()
    
    
    //MARK: OPEN ACTIONSHEET
    func openActionSheet(imageCompletionHandler:ImageCompletionHandler){
        
        let actionSheetController = UIAlertController(title: "Please select photo", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        
        //Camera
        let takePictureAction = UIAlertAction(title: "Add Image", style: .default) { action -> Void in
            self.openImagePickerWithSourceType(source: .camera,handler:imageCompletionHandler, isVideo: false)
        }
        actionSheetController.addAction(takePictureAction)
        
        
        //Video
        let takeVideoAction = UIAlertAction(title: "Add Video", style: .default) { action -> Void in
            self.openImagePickerWithSourceType(source: .camera,handler:imageCompletionHandler, isVideo: true)
        }
        actionSheetController.addAction(takeVideoAction)
        
        
        
        //Gallery
        let choosePictureAction = UIAlertAction(title: "Choose Photo", style: .default) { action -> Void in
            self.openImagePickerWithSourceType(source: .photoLibrary,handler:imageCompletionHandler,isVideo: false)
        }
        actionSheetController.addAction(choosePictureAction)
        let topVC = UIApplication.topViewController()

        topVC?.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    fileprivate func openPickerController(_ source: UIImagePickerController.SourceType, _ handler: ImageCompletionHandler, _ isVideo: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            imageHandler = handler
            self.imagePickerControll.sourceType = source
            imagePickerControll.delegate = self
            if isVideo{
                self.imagePickerControll.mediaTypes = [String(kUTTypeMovie)]
                self.imagePickerControll.videoMaximumDuration = TimeInterval(Picker_Alert.video_duration)
            }else{
                self.imagePickerControll.mediaTypes = [String(kUTTypeImage)]
            }
            self.imagePickerControll.allowsEditing = true
            let topVC = UIApplication.topViewController()
            topVC?.present(self.imagePickerControll, animated: true, completion: nil)
            
        }
    }
    
    fileprivate func checkPermission(_ source: UIImagePickerController.SourceType, _ handler: ImageCompletionHandler, _ isVideo: Bool) {
        
        if isVideo == true{
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            switch cameraAuthorizationStatus {
            case .denied:
                Alert.shared.showAlertWithHandler(title: "Please allow camera access", message: "We need to access your camera to record a video", buttonsTitles: ["Ok"], showAsActionSheet:false, handler: { (index) in
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler:nil)
                    }
                }, tagValue: 1011)
                break
            case .authorized:
                openPickerController(source, handler, isVideo)
            case .restricted: break
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    if granted {
                        print("Granted access to \(cameraMediaType)")
                    } else {
                        print("Denied access to \(cameraMediaType)")
                    }
                }
                
            }
            
        }else{
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                openPickerController(source, handler, isVideo)
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                    
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        self.openPickerController(source, handler, isVideo)
                    }else{
                        self.imageHandler!!(nil,nil,false)
                    }
                })
                break
            case .restricted:
                break
            case .denied:
                break
            }
        }
    }
    
    
    func openImagePickerWithSourceType(source:UIImagePickerController.SourceType,handler:ImageCompletionHandler,isVideo:Bool) {
        
        checkPermission(source, handler, isVideo)
        
    }
    
    
    
    //MARK: Convert Video to Thumb image
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }    
}




