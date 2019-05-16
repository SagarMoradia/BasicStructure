//
//  HSImagePicker+delegate.swift
//  Capchur
//
//  Created by Hitesh Surani on 06/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation
import Photos
import MobileCoreServices

extension imagePicker{
    //MARK: Delegates method
    
        
    //MARK: UIImage Picker delegate
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        var chosenImage:UIImage!
        
        var videoURL:URL? = nil
        
        if type ==  String(kUTTypeVideo) || type == String(kUTTypeMovie) {
            videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
            
            chosenImage = self.getThumbnailFrom(path:videoURL! as URL) ?? UIImage()
            chosenImage.imageName = (videoURL?.lastPathComponent) ?? ""
            
        }else{
            
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            {
                chosenImage = img
                
            }
            else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                chosenImage = img
            }

            
            
            if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [url] , options: nil)
                let asset = result.firstObject
                
                chosenImage.imageName = asset?.value(forKey: "filename") as? String ?? ""
                
            }else{
                let name = "\(String(randomNumber()))."+"\(chosenImage!.pngData()!.contentType)"
                chosenImage.imageName = name
            }
        }
        
        imageHandler!!(chosenImage!,videoURL,true)
        picker.dismiss(animated: true, completion:nil)
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageHandler = nil
        picker.dismiss(animated: true, completion:nil)
    }

}
