//
//  UploadVideoStep3VC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 27/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import AVKit
import AWSS3


class UploadVideoStep3VC: ParentVC {

    //MARK: - Outlets
    @IBOutlet weak var imgViewThumb: UIImageView!
    @IBOutlet weak var colSelected: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var uploadProgress: UIProgressView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUpload: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    
    //MARK: - Properties
    var dictUploadVideo = [String:Any]()
    var aryThumb = [UIImage]()
    var selectedIndexPath: IndexPath?
    var selectedImage:UIImage!
    var strThumbNameForAPI = String()
    var aryKey = [String]()
    var imgData : Data!
    var privacy = Int()
    var isFromEdit = Bool()
    var aryVideoToUpload = [Any]()
    var vidPathToUpload = String()
    
    var selectedVideoForEdit: videoListData!
    
    let width = 1920.0//1280.0//1920
    let height = 1080.0//720.0//1080

    var frames:[UIImage] = []
    private var generator:AVAssetImageGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\n------------------------------Upload Video Details--------------------------\n",dictUploadVideo)
        prepareViews()
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        
        lblUpload.text = "Upload"
        
        colSelected.register(UINib.init(nibName:"CellVideoThumb", bundle: nil), forCellWithReuseIdentifier:"CellVideoThumb")
        
        addRadius(button: btnNext)
        let url = dictUploadVideo[Upload.url] as? URL
        //getAllFrames(url: url)
    
        if url != nil{
            let images = self.getThumbnailFrom(path: url!)
            print(images as Any)
            aryThumb = images!
            aryThumb.append(UIImage())
            print(self.aryThumb)
        }else{
            if !isFromEdit{
                Alert.shared.showAlert(title: App_Name, message: "URL of video is not found")
            }
        }
        
        if self.isFromEdit{
            self.lblTitle.text = "Save Video Detail"
            self.btnNext.setTitle("SAVE", for: .normal)
            loadImageWith(imgView: imgViewThumb, url: selectedVideoForEdit.thumbnail_480 ?? "", placeHolderImageName: "")
            
            let img = imgViewThumb.image ?? UIImage()
            aryThumb.append(img)
            aryThumb.append(UIImage())
            
            if aryThumb.count > 0{
                //imgViewThumb.image = aryThumb[0]
            }else{
                imgViewThumb.backgroundColor = UIColor.lightGray
            }
        }else{
            self.lblTitle.text = "Upload Video Detail"
            self.btnNext.setTitle("PUBLISH", for: .normal)
            imgViewThumb.image = dictUploadVideo[Upload.thumbImg] as? UIImage
        }
    }
}

//MARK: - Button Event Methods
extension UploadVideoStep3VC{
    @IBAction func actionNext (_ sender : UIButton){
//        DispatchQueue.main.async {
//            self.showLoader()
//        }
        
        if selectedIndexPath != nil{
            
            if isFromEdit {
                self.callVideoUpdateAPI()
            }
            else{
                let strTitle = dictUploadVideo[Upload.title] as! String
                let catId = dictUploadVideo[Upload.category_id] as! Int
                let categoryId = String(catId)
                let tags = dictUploadVideo[Upload.tag] as! [String]
                let strTags = tags.joined(separator: ",")
                let strDesc = dictUploadVideo[Upload.description] as! String
                let strPrivacy = dictUploadVideo[Upload.privacy] as! String
                if strPrivacy == Privacy.Public{
                    privacy = 0
                }else{
                    privacy = 1
                }
                
                lblUpload.text = "Uploading..."
                
                self.makeUploadRequest(api_title: strTitle, api_category_id: categoryId, api_tag: strTags, api_description: strDesc, api_privacy: 0)
            }
            
        }
        else{
            
//            DispatchQueue.main.async {
//                self.hideLoader()
//            }
            
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_thumb, okButtonTitle: Cons_Ok) { (alert) in
            }
        }
    }
}

//MARK: - Camera Methods
extension UploadVideoStep3VC{
    @objc func openCamera(){
        let alert:UIAlertController=UIAlertController(title: Cons_Image_Picker_Title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: Cons_Camera, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            imagePicker.sharedInstance.openImagePickerWithSourceType(source: UIImagePickerController.SourceType.camera, handler: { (image, url, status) in
                print("\n-------------selected image----------------\n",image as Any)
                
                let selectedImg = self.resizeImages(with: image!, scaledTo: CGSize.init(width: self.width, height: self.height))
                
                let heightInPoints = selectedImg.size.height
                let heightInPixels = heightInPoints * selectedImg.scale
                let widthInPoints = selectedImg.size.width
                let widthInPixels = widthInPoints * selectedImg.scale
                
                print("\n-------------points----------------\n",heightInPoints)
                print("\n-------------pixels----------------\n",widthInPoints)
                
                //1920x1080
                if Int(heightInPixels) == Int(self.height) && Int(widthInPixels) == Int(self.width){
                    self.selectedIndexPath = nil
                    self.selectedImage = nil
                    self.aryThumb.removeLast()
                    self.aryThumb.append(selectedImg)
                    self.aryThumb.append(UIImage())
                    print(self.aryThumb)
                    self.colSelected.reloadData()
                }else{
                    Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_thumb, okButtonTitle: Cons_Ok) { (alert) in
                        
                    }
                }

            }, isVideo: false)
        }
        let gallaryAction = UIAlertAction(title: Cons_Gallery, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            imagePicker.sharedInstance.openImagePickerWithSourceType(source: UIImagePickerController.SourceType.photoLibrary, handler: { (image, url, status) in
                print("\n-------------selected image----------------\n",image as Any)
                let selectedImg = self.resizeImages(with: image!, scaledTo: CGSize.init(width: self.width, height: self.height))
                
                let heightInPoints = selectedImg.size.height
                let heightInPixels = heightInPoints * selectedImg.scale
                let widthInPoints = selectedImg.size.width
                let widthInPixels = widthInPoints * selectedImg.scale
                
                print("\n-------------points----------------\n",heightInPoints)
                print("\n-------------pixels----------------\n",widthInPoints)
                
                //1920x1080
                if Int(heightInPixels) == Int(self.height) && Int(widthInPixels) == Int(self.width){
                    self.selectedIndexPath = nil
                    self.selectedImage = nil
                    self.aryThumb.removeLast()
                    self.aryThumb.append(selectedImg)
                    self.aryThumb.append(UIImage())
                    print(self.aryThumb)
                    self.colSelected.reloadData()
                }else{
                    Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_thumb, okButtonTitle: Cons_Ok) { (alert) in
                        
                    }
                }
                
            }, isVideo: false)
        }
        let cancelAction = UIAlertAction(title: Cons_Cancel, style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionview Delegate and Datasource Methods
extension UploadVideoStep3VC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryThumb.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (collectionView.frame.width/2)-7
        return CGSize(width: screenWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideoThumb", for: indexPath) as! CellVideoThumb
        cell.imgView.image = aryThumb[indexPath.row]
        
        //last cell to display camera
        if indexPath.row == aryThumb.count - 1 {
            cell.viewCamera.isHidden = false
        }else{
            cell.viewCamera.isHidden = true
        }
        
        //For selected cell display
        if selectedIndexPath != nil && indexPath == selectedIndexPath {
            if indexPath.row == aryThumb.count - 1 {
                cell.viewSelected.isHidden = true
            }else{
                cell.viewSelected.isHidden = false
            }
        }else{
            cell.viewSelected.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideoThumb", for: indexPath) as! CellVideoThumb
        DispatchQueue.main.async {
            cell.viewSelected.isHidden = false
            self.selectedIndexPath = indexPath
            //open camera at last cell
            if indexPath.row == self.aryThumb.count - 1 {
                self.openCamera()
                //self.selectedIndexPath = nil
            }else{
                let image = self.aryThumb[indexPath.row]
                self.selectedImage = image
                self.strThumbNameForAPI = image.imageName
                self.imgData = image.jpegData(compressionQuality: 0.5)!
                self.colSelected.reloadData()
            }
        }
    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideoThumb", for: indexPath) as! CellVideoThumb
//        DispatchQueue.main.async {
//            cell.viewSelected.isHidden = true
//            self.selectedIndexPath = nil
//            self.selectedImage = nil
//            self.colSelected.reloadData()
//        }
//    }
}

//MARK: Convert Video to Thumb image
extension UploadVideoStep3VC{
    //create thumbnail at every 15 seconds
    func getThumbnailFrom(path: URL) -> [UIImage]? {
        var aryImg = [UIImage]()
        let asset = AVURLAsset(url: path , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        print(durationTime)
        //let lastCount = Int(durationTime/15.0)
        //var fps = 0
        
        //sweta changes
        //create thumbnail at every 1 second
        var fps = 1
        var lastCount = Int()
        let videoTime = Int(durationTime)
        if videoTime < 120{
            lastCount = 3
            fps = videoTime/lastCount
        }
        else if videoTime > 120{
            lastCount = 6
            fps = videoTime/lastCount
        }
        
        let divident = fps
        //for _ in 0...lastCount{
        for _ in 1...lastCount{
            do {
                let time:CMTime = CMTimeMakeWithSeconds(Float64(fps), preferredTimescale:600)
                let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
                var thumbnail = UIImage(cgImage: cgImage)
                
                thumbnail = self.resizeImage(image: thumbnail, targetSize: CGSize(width: self.width , height: self.height))
                
                aryImg.append(thumbnail)
                
                fps = fps + divident
                //fps = fps + 15
            } catch let error {
                Alert.shared.showAlertWithHandler(title: App_Name, message: "Error generating thumbnail", okButtonTitle: Cons_Ok) { (alert) in
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
            }
        }
        return aryImg
    }
    
    //get frames at every second
    func getAllFrames(url : URL) {
        let asset:AVAsset = AVAsset(url:url)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        self.frames = []
        
        for index:Int in 0 ..< Int(duration) {
            self.getFrame(fromTime:Float64(index))
        }
        self.generator = nil
    }
    
    private func getFrame(fromTime:Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
        let image:CGImage
        do {
            try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
            return
        }
        self.frames.append(UIImage(cgImage:image))
        print(self.frames)
    }
}

//MARK: - AWS Video Upload
extension UploadVideoStep3VC{
 
    func makeUploadRequest(api_title:String,api_category_id:String,api_tag:String,api_description:String,api_privacy:Int){
        
        //For Video
        let storyID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as! String
        
        let url = dictUploadVideo[Upload.url] as? URL
        
        let path = dictUploadVideo[Upload.strUrl] as! String
        let comp = path.components(separatedBy: ".")
        let fileExtension = comp.last ?? ""
        
        self.vidPathToUpload = GLOBAL.sharedInstance.getAwsPathForVid(storyID:storyID, fileExtension:fileExtension)
        var videoName = String()
        let urlForName = URL(fileURLWithPath: self.vidPathToUpload)
        if self.vidPathToUpload != ""{
            videoName = urlForName.lastPathComponent
        }
        
        self.setUserInteractionEnable(enable: false)
        
        self.uploadVideoOnS3(fileUrl: url!, fileName: videoName, api_title: api_title, api_category_id: api_category_id, api_tag: api_tag, api_description: api_description, api_privacy: api_privacy)
    }
    
    func uploadVideoOnS3(fileUrl : URL,fileName:String,api_title:String,api_category_id:String,api_tag:String,api_description:String,api_privacy:Int){
        
        let newKey = "uploads/videos/\(fileName)"
        print("*****-----***** \(newKey) *****-----*****")
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = fileUrl as URL
        uploadRequest?.key = newKey
        uploadRequest?.bucket = AWSConstant.AWS_BUCKET_NAME
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.contentType = "movie/mov"
        
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                let progress = (CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)) as CGFloat
                self.lblProgress.isHidden = false
                self.uploadProgress.isHidden = false
                self.uploadProgress.progress = Float(progress)
                
                let progressPercent = Int(progress*100)
                
                if progressPercent <= 100
                {
                    self.lblProgress.text = "Uploading \(progressPercent)%"
                }
                else {
                     self.showLoader()
                }
                
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) in
            if task.error != nil {
                print(task.error.debugDescription)
                self.setUserInteractionEnable(enable: true)
            } else {
                // Do something with your result.
                print("*****-----***** Video Uploaded to AWS S3 *****-----*****")
                print("*****-----***** \(fileName) *****-----*****")
                self.setUserInteractionEnable(enable: true)
                self.callUploadVideoAPI(title: api_title, category_id: api_category_id, tag: api_tag, description: api_description, privacy: api_privacy, videoName: fileName)
            }
            return nil
        })
    }
    
    func setUserInteractionEnable(enable:Bool){
        self.viewMain.isUserInteractionEnabled = enable
        self.btnNext.isEnabled = enable
        self.navigationItem.leftBarButtonItem?.isEnabled = enable
    }
    
    ///Resizing the images
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

//MARK: - API Methods
extension UploadVideoStep3VC{
    func callUploadVideoAPI(title:String,category_id:String,tag:String,description:String,privacy:Int,videoName:String)  {
        
        self.showLoader()
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Form_Data)
        
        let queryParams = NSMutableDictionary()
        queryParams.setValue(title, forKey: KEYS_API.title)
        queryParams.setValue(category_id, forKey: KEYS_API.category_id)
        queryParams.setValue(description, forKey: KEYS_API.description)
        queryParams.setValue(tag, forKey: KEYS_API.tag)
        queryParams.setValue(privacy, forKey: KEYS_API.privacy)
        queryParams.setValue(videoName, forKey: KEYS_API.videoName)
        queryParams.setValue("1", forKey: KEYS_API.ismobile)
        
        print("\n-------------------------Parameters :-----------------------\n",queryParams)
        
        //For Thumb image
        if self.imgData != nil{
            aryKey.append(KEYS_API.thumbnail)
        }
        
        //ModelSetAccountSettings
        API.sharedInstance.multipartRequestWithModalClassForS3Video(modelClass: ModelRegistration.self, apiName: APIName.VideoCreate,fileName:self.strThumbNameForAPI,keyName:aryKey,fileData:imgData, requestType: .post, paramValues: (queryParams as! Dictionary<String, Any>), headersValues: headerParams, isFromEdit: false, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode = response.meta?.status_code
            
            if self.handleStatusCode(statusCode: statusCode!, modelErrors: response.errors, meta: response.meta) {
                
                let vUuid = response.data!.uuid ?? ""
                
                let msg = response.meta?.message ?? ""
                
                GLOBAL.sharedInstance.selectedCatIDsToUpload = ""
                GLOBAL.sharedInstance.selectedCatNamesToUpload = ""
                GLOBAL.sharedInstance.arrCategory = NSMutableArray()
                let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep4VC") as! UploadVideoStep4VC
                controller.videoUuid = vUuid
                controller.msgSuccess = msg
                controller.isFromEdit = self.isFromEdit
                controller.hidesBottomBarWhenPushed = true
                self.PUSH_STORY_OBJ(obj: controller)
                
                //                Alert.shared.showAlertWithHandler(title: App_Name, message: msg, okButtonTitle: Cons_Ok, handler: { (action) in
                //                })
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
            
        }, ProgressHandler: { (progress) in
            //            print("progress: \(progress)")
            //            self.lblProgress.isHidden = false
            //            self.uploadProgress.isHidden = false
            //            let progress = Float(progress.fractionCompleted)
            //            self.uploadProgress.progress = progress
            //            let progressPercent = Int(progress*100)
            //            self.lblProgress.text = "Uploading \(progressPercent)%"
        })
    }
    
    func callVideoUpdateAPI()  {
        
        self.showLoader()
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let v_uuid = selectedVideoForEdit.uuid
        let strTitle = dictUploadVideo[Upload.title] as! String
        let categoryId = dictUploadVideo[Upload.category_id] as! String
        let tags = dictUploadVideo[Upload.tag] as! [String]
        let strTags = tags.joined(separator: ",")
        let strDesc = dictUploadVideo[Upload.description] as! String
        
        let queryParams = NSMutableDictionary()
        queryParams.setValue(strTitle, forKey: KEYS_API.title)
        queryParams.setValue(categoryId, forKey: KEYS_API.category_id)
        queryParams.setValue(strDesc, forKey: KEYS_API.description)
        queryParams.setValue(strTags, forKey: KEYS_API.tag)
        queryParams.setValue(0, forKey: KEYS_API.privacy)
        queryParams.setValue(v_uuid, forKey: KEYS_API.uuid)
        queryParams.setValue("Yes", forKey: KEYS_API.ispublish)
        
        print("\n-------------------------Parameters :-----------------------\n",queryParams)

        //For Thumb image
        if self.imgData != nil{
            aryKey.append(KEYS_API.thumbnail)
        }
        
        API.sharedInstance.multipartRequestWithModalClassForS3Video(modelClass: EditVideoModel.self, apiName: APIName.VideoUpdate,fileName:self.strThumbNameForAPI,keyName:aryKey,fileData:imgData, requestType: .post, paramValues: (queryParams as! Dictionary<String, Any>), headersValues: headerParams, isFromEdit: false, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode = response.meta?.status_code
            
            if self.handleStatusCode(statusCode: statusCode!, modelErrors: response.errors, meta: response.meta) {
                
                let vUuid = response.data!.uuid ?? ""
                let msg = response.meta?.message ?? ""
                
                GLOBAL.sharedInstance.selectedCatIDsToUpload = ""
                GLOBAL.sharedInstance.selectedCatNamesToUpload = ""
                GLOBAL.sharedInstance.arrCategory = NSMutableArray()
                let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep4VC") as! UploadVideoStep4VC
                controller.videoUuid = vUuid
                controller.msgSuccess = msg
                controller.isFromEdit = self.isFromEdit
                controller.hidesBottomBarWhenPushed = true
                self.PUSH_STORY_OBJ(obj: controller)
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
            
        }, ProgressHandler: { (progress) in
        })
    }
}
