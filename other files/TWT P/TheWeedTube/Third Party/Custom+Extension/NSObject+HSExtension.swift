//
//  NSObject+Extension.swift
//  Capchur
//
//  Created by Hitesh Surani on 06/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation
//import SDWebImage

private var AssociatedObjectHandle: UInt8 = 0
private var AssociatedObjectHandleLat: UInt8 = 0
private var AssociatedObjectHandleLong: UInt8 = 0
private var AssociatedObjectHandleDate: UInt8 = 0
private var AssociatedObjectAPIType: UInt8 = 0

extension NSObject {
    
//    var APITypeConst : String {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedObjectAPIType) as? String ?? ""
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedObjectAPIType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
    
    var imageName : String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var customID : Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? -1
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var CustomType : String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }    
    
        
    func randomNumber() -> Int {
        let randomNumber = Int(arc4random_uniform(UInt32(INT_MAX)))
        return randomNumber
    }

    func loadImageWith(imgView: UIImageView?, url: String?) {
        if imgView != nil{
            loadImageWith(imgView: imgView!, url: url, type: UIActivityIndicatorView.Style.gray.rawValue)
        }
    }
    
    func loadImageWith(imgView: UIImageView?, url: String?,placeHolderImageName:String) {        
        if let imgView = imgView{
            imgView.sd_setImage(with: URL(string:url ?? ""), placeholderImage: UIImage(named:placeHolderImageName), options: .highPriority) { (image, error, catchType, url) in
                if (image != nil){
                    if ((image) != nil){
//                        imgView.image = self.ResizeImage(image: imgView.image ?? UIImage(), targetSize: CGSize(width:imgView.frame.size.width, height:imgView.frame.size.height))
                        
                    }
                }
            }
        }
    }
    
    func loadImageWith(imgView: UIImageView, url: String?,type:Int) {
        
//        imgView.sd_setShowActivityIndicatorView(true)
//        imgView.sd_setIndicatorStyle(UIActivityIndicatorView.Style(rawValue:type)!)
        if url != nil {
            imgView.sd_setImage(with: URL.init(string: url!), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                imgView.image = image
            })
        }
    }
    
    func loadImageWithCroping(imgView: UIImageView, url: String?,type:Int) {
        
        let imageViewTemp = UIImageView(frame: imgView.bounds)
        
        guard let tempSuperView = imgView.superview else {
            return
        }
        
        tempSuperView.isUserInteractionEnabled = false
//        imageViewTemp.sd_setShowActivityIndicatorView(true)
//        imageViewTemp.sd_setIndicatorStyle(UIActivityIndicatorView.Style(rawValue:type)!)
        tempSuperView.addSubview(imageViewTemp)
        
        
        if url != nil {
            imageViewTemp.sd_setImage(with: URL.init(string: url!), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                
                imageViewTemp.removeFromSuperview()
                tempSuperView.isUserInteractionEnabled = true
                
                guard let image = image else{
                    return
                }
                
                DispatchQueue.main.async {
                    
                    imgView.isHidden = false
                    
                    let newThumbImage = self.resizeImage(image: image, maxHeight: Float(imgView.frame.height), maxWidth: Float(imgView.frame.width))
                    
                    guard let superView = imgView.superview as? UIScrollView else {
                        return
                    }
                    let imgNewWidth = newThumbImage.size.width
                    let imgNewHeight = newThumbImage.size.height
                    
                    let imgXPosition = (superView.frame.width) - imgNewWidth
                    let imgYPosition = (superView.frame.height/2) - (imgNewHeight/2)
                    
                    imgView.frame = CGRect.init(x:imgXPosition, y: imgYPosition, width:imgNewWidth, height: imgNewHeight)
                    
                    self.adjustFrameToCenter(unwrappedZoomView: imgView, scrollView: superView)
                    imgView.image = image
                }
                
            })
        }
    }
    
    func loadImageWithCroping(imgView: UIImageView, image:UIImage) {
        imgView.isHidden = false
        let newThumbImage = self.resizeImage(image: image, maxHeight: Float(imgView.frame.height), maxWidth: Float(imgView.frame.width))
        guard let superView = imgView.superview as? UIScrollView else {
            return
        }
        let imgNewWidth = newThumbImage.size.width
        let imgNewHeight = newThumbImage.size.height
        let imgXPosition = (superView.frame.width) - imgNewWidth
        let imgYPosition = (superView.frame.height/2) - (imgNewHeight/2)
        imgView.frame = CGRect.init(x:imgXPosition, y: imgYPosition, width:imgNewWidth, height: imgNewHeight)
        self.adjustFrameToCenter(unwrappedZoomView: imgView, scrollView: superView)
        imgView.image = image
    }
    
    func resizeImage(image: UIImage,maxHeight:Float,maxWidth:Float) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 1.0
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        //let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
        
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
    func adjustFrameToCenter(unwrappedZoomView:UIImageView,scrollView:UIScrollView) {
        
        
        var frameToCenter = unwrappedZoomView.frame
        
        // center horizontally
        if frameToCenter.size.width < scrollView.bounds.width {
            frameToCenter.origin.x = (scrollView.bounds.width - frameToCenter.size.width) / 2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < scrollView.bounds.height {
            frameToCenter.origin.y = (scrollView.bounds.height - frameToCenter.size.height) / 2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        unwrappedZoomView.frame = frameToCenter
    }
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
