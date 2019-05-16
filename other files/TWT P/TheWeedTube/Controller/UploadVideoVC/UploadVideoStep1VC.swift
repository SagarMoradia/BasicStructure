//
//  UploadVideoStep1.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 25/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import AssetsLibrary
import AVFoundation
import Photos

struct Upload {
    static let thumbImg = "thumbImg"
    static let url = "url"
    static let strUrl = "strUrl"
    static let title = "title"
    static let category_id = "category_id"
    static let description = "description"
    static let tag = "tag"
    static let privacy = "privacy"
    static let uuid = "uuid"
    static let fileSize = "fileSize"
}

class UploadVideoStep1VC: ParentVC {
    
    //MARK: - Outlets
    @IBOutlet weak var colSelected: UICollectionView!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    
    
    //MARK: - Properties
    var photos: PHFetchResult<PHAsset>!
    var thumbImg = UIImage()
    var urlImg : URL?
    var strUrl = String()
    var dictUploadVideo = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GLOBAL.sharedInstance.selectedCatIDsToUpload = ""
        GLOBAL.sharedInstance.selectedCatNamesToUpload = ""
        GLOBAL.sharedInstance.arrCategory = NSMutableArray()
    }

    //MARK: - Intial Methods
    func prepareViews() {
        self.lblNoData.isHidden = true
        colSelected.register(UINib.init(nibName:"CellVideo", bundle: nil), forCellWithReuseIdentifier:"CellVideo")
        getAssetFromPhoto()
    }
}

 //MARK: - Get Videos Methods
extension UploadVideoStep1VC{
    func getAssetFromPhoto() {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ] //modificationDate //creationDate
//        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        options.predicate = NSPredicate(format: "mediaType = %d AND duration > 30", PHAssetMediaType.video.rawValue)
        photos = PHAsset.fetchAssets(with: options)
        print(photos)
        if photos.count > 0{
            self.lblNoData.isHidden = true
            colSelected.reloadData()
        }else{
            self.lblNoData.isHidden = false
        }
    }
}

//MARK: - Button Event Methods
extension UploadVideoStep1VC{
    @IBAction func actionRecordVideo (sender : UIControl){
//        
//        let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep2VC") as! UploadVideoStep2VC
//        //controller.dictUploadVideo = self.dictUploadVideo
//        self.PUSH_STORY_OBJ(obj: controller)
//
//        return
        imagePicker.sharedInstance.openImagePickerWithSourceType(source: UIImagePickerController.SourceType.camera, handler: { (image, url, status) in
            //print("\n---------------URL of image----------------\n",url as! URL)
            let img = imagePicker.sharedInstance.getThumbnailFrom(path: url!)
            
            self.dictUploadVideo = [Upload.thumbImg : img as Any,
                                        Upload.strUrl : (url?.absoluteString)!,
                                        Upload.url : url as Any]
            
            let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep2VC") as! UploadVideoStep2VC
            controller.dictUploadVideo = self.dictUploadVideo
            self.PUSH_STORY_OBJ(obj: controller)
           
        }, isVideo: true)
    }
}

//MARK: - UICollectionview Delegate and Datasource Methods
extension UploadVideoStep1VC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (collectionView.frame.width/3)-3
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideo", for: indexPath) as! CellVideo
        
        let asset = photos!.object(at: indexPath.row)
        let width: CGFloat = 100
        let height: CGFloat = 100
        let size = CGSize(width:width, height:height)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, userInfo) -> Void in
            cell.imgView.image = image
            cell.lblTime.text = self.timeFormatted(totalSeconds: asset.duration)
            //cell.lblTime.text = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let asset = photos!.object(at: indexPath.row)
        guard(asset.mediaType == PHAssetMediaType.video)
            else {
                print("Not a valid video media type")
                return
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width:500, height:500), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, userInfo) in
            self.thumbImg = image!
        }
        
        
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (asset:AVAsset?, audioMix:AVAudioMix?, [AnyHashable : Any]?) in
            
            if asset!.isKind(of: AVComposition.self){
                self.showLoader()
                self.ConvertAvcompositionToAvasset(avComp: asset as! AVComposition, completion: { (asset) in
                    
                    self.hideLoader()
                    let asset = asset as! AVURLAsset
                    print(asset.url)
                    let url = asset.url
                    self.urlImg = url
                    self.strUrl = url.absoluteString
                    
                    DispatchQueue.main.async {
                        self.dictUploadVideo = [Upload.thumbImg : self.thumbImg as Any,
                                                Upload.strUrl : self.strUrl,
                                                Upload.url : self.urlImg as Any]
                        
                        let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep2VC") as! UploadVideoStep2VC
                        controller.dictUploadVideo = self.dictUploadVideo
                        self.PUSH_STORY_OBJ(obj: controller)
                    }
                })
            }
            else{
                let asset = asset as! AVURLAsset
                print(asset.url)
                let videoOptions = PHVideoRequestOptions()
                videoOptions.isNetworkAccessAllowed = true
                videoOptions.deliveryMode = .fastFormat
                let url = asset.url
                self.urlImg = url
                self.strUrl = url.absoluteString
                
                DispatchQueue.main.async {
                    self.dictUploadVideo = [Upload.thumbImg : self.thumbImg as Any,
                                            Upload.strUrl : self.strUrl,
                                            Upload.url : self.urlImg as Any]
                    
                    let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep2VC") as! UploadVideoStep2VC
                    controller.dictUploadVideo = self.dictUploadVideo
                    self.PUSH_STORY_OBJ(obj: controller)
                }
            }
        }
    }
    func ConvertAvcompositionToAvasset(avComp: AVComposition, completion:@escaping (_ avasset: AVAsset) -> Void){
        let exporter = AVAssetExportSession(asset: avComp, presetName: AVAssetExportPresetHighestQuality)
        let randNum:Int = Int(arc4random())
        //Generating Export Path
        let exportPath: NSString = NSTemporaryDirectory().appendingFormat("\(randNum)"+"video.mov") as NSString
        let exportUrl: NSURL = NSURL.fileURL(withPath: exportPath as String) as NSURL
        //SettingUp Export Path as URL
        exporter?.outputURL = exportUrl as URL
        exporter?.outputFileType = AVFileType.mov
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                if exporter?.status == .completed {
                    let URL: URL? = exporter?.outputURL
                    let Avasset:AVAsset = AVAsset(url: URL!)
                    completion(Avasset)
                }
                else if exporter?.status == .failed{
                    print("Failed")
                }
            })
        })
    }
}

//MARK: - Time Methods
extension UploadVideoStep1VC{
    func timeFormatted(totalSeconds: Float64) -> String {
        let timeInterval: TimeInterval = totalSeconds
        let seconds: Int = lround(timeInterval)
        var hour: Int = 0
        var minute: Int = Int(seconds/60)
        let second: Int = seconds % 60
        if minute > 59 {
            hour = minute / 60
            minute = minute % 60
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        else {
            return String(format: "%02d:%02d", minute, second)
        }
    }
}
