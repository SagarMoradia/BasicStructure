//
//  VideoDetailVC.swift
//  TheWeedTube
//
//  Created by Vivek Bhoraniya on 05/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation


class VideoDetailVC: ParentVC, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var  viewMain : UIView!
    @IBOutlet weak var tblvVideoDetail: UITableView!
    @IBOutlet weak var  viewVideo : UIView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var viewTop: UIView!
    var showControl : Bool = false
    
    var jwPlayer: JWPlayerController!
    var config: JWConfig = JWConfig()
    var arrPlaylist = [JWPlaylistItem]()
    @IBOutlet var callbacksView: UITextView!
    @IBOutlet var playbackTime: UILabel!
    @IBOutlet var playButton: UIButton!
    
    var viewAddStash : AddToStashActionSheet?
    var viewReportSheet : ReportActionSheet?
    var strSelectedVideoId = ""
    var strPlaylistVideoId = ""
    var modelVideoDetailData : Model_VideoDetailData? = nil
    var aryRecommendedVideos = [Model_VideoData]()
    var aryVideoComments = [Model_CommentListingData]()
    var aryPlaylistVideos = [playlistMainData]()
    var modelPlaylistInfo : PlaylistInfo? = nil
    var modelPlaylist : playlistOriginal? = nil
    var totalRecords: Int = 0
    var isViewMore_Playlist = true
    var isViewMore_Recommended = true
    var isViewMore_Comments = true
    var isFromViewReplies = Bool()
    
    var isFullScreen: Bool = false
    
    //For Sort By
    var selectedIndexPath: IndexPath?
    
    //For Playlist
    var isFromPlaylist = Bool()
    var indexOfPlaylist: Int = 0
    
    //For expand/collapse
    var selectedIndx = -1
    var cellTapped = false
    var selectedIndxCategory = -1
    var cellCategoryTapped = false
    var expandHeight = CGFloat()
    
    //For play icon
    var selectedIndexPathForPlay: IndexPath?
    
    //pop up
    var viewComments = Bundle.loadView(fromNib:"CommentsView", withType: CommentsView.self)
    var viewKeyboard = Bundle.loadView(fromNib:"KeyboardView", withType: KeyboardView.self)
    var topHeaderView = Bundle.loadView(fromNib:"VideoDetailPlaylistView", withType: VideoDetailPlaylistView.self)
    
    //Callback
    var handler: indexHandlerBlock!
    
    //MARK:- UIViewController Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addClicked(_:)), name: NSNotification.Name(rawValue: NOTIFICATION_NAME.On_Add_Clicked), object: nil)
        
        //self.setupDeviceOrientation()
        
        tblvVideoDetail.register(UINib(nibName: "VideoDetailsCell", bundle: nil), forCellReuseIdentifier: "VideoDetailsCell")
        tblvVideoDetail.register(UINib(nibName: "VideoPlaylistCell", bundle: nil), forCellReuseIdentifier: "VideoPlaylistCell")
        tblvVideoDetail.register(UINib(nibName: "VideoListCell", bundle: nil), forCellReuseIdentifier: "VideoListCell")
        tblvVideoDetail.register(UINib(nibName: "VideoCommentCell", bundle: nil), forCellReuseIdentifier: "VideoCommentCell")
        tblvVideoDetail.register(UINib(nibName: "AdvertiesCell", bundle: nil), forCellReuseIdentifier: "AdvertiesCell")
        
        tblvVideoDetail.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        tblvVideoDetail.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        
        if GLOBAL.sharedInstance.isFromNotification{
            self.strSelectedVideoId = GLOBAL.sharedInstance.Notification_uuid
            GLOBAL.sharedInstance.isFromNotification = false
        }
        
        self.viewComments.frame = CGRect.init(x: 0, y: 2000, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.viewKeyboard.frame = CGRect.init(x: 0, y: 2000, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.parentView.isHidden = true
        if isFromPlaylist{
            selectedIndexPathForPlay = NSIndexPath(row: 0, section: 1) as IndexPath
        }
        
        self.initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.viewTop.isHidden = true
        }
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyForVideo(_:)), name: NSNotification.Name(rawValue: NOTIFICATION_NAME.VideoNotification), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //removeKeyboardObserver()
        
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK:- Helper Methods
    @objc func notifyForVideo(_ notification: NSNotification){
        if notification.name.rawValue == NOTIFICATION_NAME.VideoNotification{
            self.strSelectedVideoId = GLOBAL.sharedInstance.Notification_uuid
            GLOBAL.sharedInstance.isFromNotification = false
            self.initialSetup()
        }
    }
    
    func setupDeviceOrientation() {
        
        let didRotate: (Notification) -> Void = { notification in
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                print("***----- Landscape -----***")
                self.isFullScreen = true
                self.onFullscreenToggled(fullscreen: self.isFullScreen)
            case .portrait, .portraitUpsideDown:
                print("***----- Portrait ------***")
                self.isFullScreen = false
                self.onFullscreenToggled(fullscreen: self.isFullScreen)
            default:
                print("other")
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                               object: nil,
                                               queue: .main,
                                               using: didRotate)
    }
    
    func initialSetup(){
        
        modelVideoDetailData = nil
        modelPlaylistInfo = nil
        modelPlaylist = nil
        aryRecommendedVideos = [Model_VideoData]()
        aryVideoComments = [Model_CommentListingData]()
        aryPlaylistVideos = [playlistMainData]()
        totalRecords = 0
        isViewMore_Playlist = true
        isViewMore_Recommended = true
        isViewMore_Comments = true
        isFromViewReplies = false
        
        self.callVideoDetailAPI()
        
        //self.setupDeviceOrientation()
    }
    
    //MARK:- UITableViewDelegate & UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isFromPlaylist{
            if(section == 0) //Video Description
            {
                return 1
            }
            else if (section == 1)
            {
                return 1
            }
            else if(section == 2) //Playlist section
            {
                return self.aryPlaylistVideos.count
            }
            else if (section == 3) // Recommended Videos
            {
                return self.aryRecommendedVideos.count
            }
            else if (section == 4)
            {
                return 1
            }
            else
            { //Video Comments List
                return self.aryVideoComments.count
            }
        }else{
            if(section == 0) //Video Description
            {
                return 1
            }
            else if (section == 1)
            {
                return 1
            }
            else if(section == 2) // Recommended Videos
            {
                return self.aryRecommendedVideos.count
            }
            else if (section == 3)
            {
                return 1
            }
            else
            { //Video Comments List
                return self.aryVideoComments.count
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFromPlaylist{
            return 6
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isFromPlaylist{
            if(section == 0) //Video Description
            {
                return 0.01
            }
            else if(section == 1)
            {
                return 0.01
            }
            else if (section == 2) //Playlist section
            {
                return 50
            }
            else if(section == 3) // Recommended Videos
            {
                return (self.aryRecommendedVideos.count > 0) ? 50 : 0
            }
            else if(section == 4)
            {
                return 0.01
            }
            else{//Video Comments List
                return 115
            }
        }else{
            if(section == 0) //Video Description
            {
                return 0.01
            }
            else if(section == 1)
            {
                return 0.01
            }
            else if(section == 2) // Recommended Videos
            {
                return (self.aryRecommendedVideos.count > 0) ? 50 : 0
            }
            else if(section == 3)
            {
                return 0.01
            }
            else{//Video Comments List
                return 115
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isFromPlaylist{
            if(section == 0) //Video Description
            {
                return 0.01
            }
            else if(section == 1)
            {
                return 0.01
            }
            else if (section == 2) //View More - Playlist section
            {
                if section == selectedIndx && cellTapped{
                    return (self.isViewMore_Playlist) ? 60 : 0
                }else{
                    return 0
                }
            }
            else if(section == 3) // Recommended Videos
            {
                return (self.isViewMore_Recommended) ? 60 : 0
            }
            else if(section == 4)
            {
                return 0.01
            }
            else{ //View More - Video Comments List
                return (self.isViewMore_Comments) ? 60 : 0
            }
        }else{
            if(section == 0) //Video Description
            {
                return 0.01
            }
            else if(section == 1)
            {
                return 0.01
            }
            else if(section == 2) // Recommended Videos
            {
                return (self.isViewMore_Recommended) ? 60 : 0
            }
            else if(section == 3)
            {
                return 0.01
            }
            else{ //View More - Video Comments List
                return (self.isViewMore_Comments) ? 60 : 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isFromPlaylist{
            if(section == 0) //Video Description
            {
                return UIView.init()
            }
            else if(section == 1)
            {
                return UIView.init()
            }
            else if (section == 2) //Playlist Footer
            {
                let viewTitle:UIControl = UIControl.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
                viewTitle.backgroundColor = UIColor.white_border_color
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 25, width: viewTitle.frame.width, height: 10))
                lblTitle.textAlignment = .center
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                lblTitle.textColor = UIColor.theme_green
                lblTitle.text = Cons_View_More
                viewTitle.addSubview(lblTitle)
                
                viewTitle.addTarget(self, action:#selector(btnViewMorePlaylistTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
            else if(section == 3) // Recommended Videos
            {
                //Video List Footer
                let viewTitle:UIControl = UIControl.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
                viewTitle.backgroundColor = UIColor.white
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 25, width: viewTitle.frame.width, height: 10))
                lblTitle.textAlignment = .center
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                lblTitle.textColor = UIColor.theme_green
                lblTitle.text = Cons_View_More
                viewTitle.addSubview(lblTitle)
                
                viewTitle.addTarget(self, action:#selector(btnViewMoreVideoTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
            else if(section == 4)
            {
                return UIView.init()
            }
            else
            {
                //Comment List Footer
                let viewTitle:UIControl = UIControl.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                viewTitle.backgroundColor = UIColor.white
                
                let viewSeprator:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
                viewSeprator.backgroundColor = UIColor.seperator_color
                
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 25, width: viewTitle.frame.width, height: 10))
                lblTitle.textAlignment = .center
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                lblTitle.textColor = UIColor.theme_green
                lblTitle.text = Cons_View_More_Comments
                viewTitle.addSubview(lblTitle)
                viewTitle.addSubview(viewSeprator)
                
                viewTitle.addTarget(self, action:#selector(btnViewMoreCommentTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
        }else{
            if(section == 0) //Video Description
            {
                return UIView.init()
            }
            else if(section == 1)
            {
                return UIView.init()
            }
            else if(section == 2) // Recommended Videos
            {
                //Video List Footer
                let viewTitle:UIControl = UIControl.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
                viewTitle.backgroundColor = UIColor.white
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 25, width: viewTitle.frame.width, height: 10))
                lblTitle.textAlignment = .center
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                lblTitle.textColor = UIColor.theme_green
                lblTitle.text = Cons_View_More
                viewTitle.addSubview(lblTitle)
                
                viewTitle.addTarget(self, action:#selector(btnViewMoreVideoTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
            else if(section == 3)
            {
                return UIView.init()
            }
            else
            {
                //Comment List Footer
                let viewTitle:UIControl = UIControl.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                viewTitle.backgroundColor = UIColor.white
                
                let viewSeprator:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
                viewSeprator.backgroundColor = UIColor.seperator_color
                
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 25, width: viewTitle.frame.width, height: 10))
                lblTitle.textAlignment = .center
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                lblTitle.textColor = UIColor.theme_green
                lblTitle.text = Cons_View_More_Comments
                viewTitle.addSubview(lblTitle)
                viewTitle.addSubview(viewSeprator)
                
                viewTitle.addTarget(self, action:#selector(btnViewMoreCommentTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFromPlaylist{
            if(section == 0) //Video Description
            {
                return UIView.init()
            }
            else if(section == 1)
            {
                return UIView.init()
            }
            else if (section == 2) //Playlist Header
            {
                //let playlistHeader = Bundle.loadView(fromNib:"VideoDetailPlaylistView", withType:VideoDetailPlaylistView.self)
                self.topHeaderView.btnExpand.tag = section
                self.topHeaderView.btnExpand.addTarget(self, action: #selector(btnExpandPlaylistTap(sender:)), for: UIControl.Event.touchUpInside)
                self.topHeaderView.lblTotalVideos.text = "(\(self.modelPlaylist?.recordsTotal ?? 0) Videos)"
                return self.topHeaderView
            }
            else if(section == 3) // Recommended Videos
            {
                //Video List Header
                let viewTitle:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                viewTitle.backgroundColor = UIColor.white
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 16, y: 16, width: 200, height: 18))
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 18.0)
                lblTitle.textColor = UIColor.textColor_black
                lblTitle.text = Cons_Recommended_Videos
                
                viewTitle.addSubview(lblTitle)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
            else if(section == 4)
            {
                return UIView.init()
            }
            else
            {
                //Comment List Header
                let viewTitle:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 115))
                viewTitle.backgroundColor = UIColor.white
                
                let viewSeprator:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
                viewSeprator.backgroundColor = UIColor.seperator_color
                
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 17, y: 8, width: UIScreen.main.bounds.width - 114, height: 22))
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 18.0)
                lblTitle.textColor = UIColor.textColor_black
                lblTitle.text = "\(self.modelVideoDetailData?.comment_count ?? 0) Comments"
                
                let viewSortBy:UIControl = UIControl.init(frame: CGRect.init(x: lblTitle.frame.maxX + 10, y: 8, width: 70, height: 22))
                
                let lblSortBy:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 22))
                lblSortBy.font = UIFont.init(name: FontFamily.medium, size: 13.0)
                lblSortBy.textColor = UIColor.theme_green
                lblSortBy.text = Cons_Sort_by
                lblSortBy.textAlignment = .center
                
                let imgView:UIImageView = UIImageView.init(frame: CGRect.init(x: lblSortBy.frame.maxX + 5, y: 6, width: 10, height: 10))
                imgView.contentMode = .scaleAspectFit
                imgView.image = UIImage.init(named: "down_arrow_green")
                
                viewTitle.addSubview(viewSeprator)
                viewTitle.addSubview(lblTitle)
                viewTitle.addSubview(viewSortBy)
                viewSortBy.addSubview(lblSortBy)
                viewSortBy.addSubview(imgView)
                
                let viewComment = UIView.init(frame:CGRect.init(x: 17, y:lblTitle.frame.maxY + 15, width: UIScreen.main.bounds.width - 34, height: 55))
                viewComment.backgroundColor = UIColor.seperator_color
                
                let imgvProfile:UIImageView = UIImageView.init()
                imgvProfile.frame = CGRect.init(x: 6, y:(55/2) - 18, width: 36, height: 36)
                imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                //imgvProfile.backgroundColor = UIColor.red
                imgvProfile.clipsToBounds = true
                
                if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                    imgvProfile.frame = CGRect(x: 6.0, y:(55/2) - 12, width: 24.0, height: 24.0)
                    imgvProfile.image = UIImage.init(named: Cons_Profile_Image_Name)
                    imgvProfile.contentMode = .scaleAspectFit
                    imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                    imgvProfile.clipsToBounds = true
                }else{
                    let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String
                    if self.verifyUrl(urlString: profileURL){
                        imgvProfile.frame = CGRect(x: 6.0, y:(55/2) - 18, width: 36.0, height: 36.0)
                        loadImageWith(imgView: imgvProfile, url: profileURL)
                        imgvProfile.contentMode = .scaleAspectFill
                        imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                        imgvProfile.clipsToBounds = true
                    }else{
                        imgvProfile.frame = CGRect(x: 6.0, y: (55/2) - 12, width: 24.0, height: 24.0)
                        imgvProfile.image = UIImage(named: Cons_Profile_Image_Name)
                        imgvProfile.contentMode = .scaleAspectFit
                        imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                        imgvProfile.clipsToBounds = true
                    }
                }
                
                let txtComment:UITextField = UITextField.init()
                txtComment.backgroundColor = UIColor.white
                txtComment.layer.cornerRadius = 3
                txtComment.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtComment.frame.height))
                txtComment.leftViewMode = .always
                txtComment.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                txtComment.textColor = UIColor.textColor_gray
                txtComment.autocorrectionType = .no
                
                txtComment.placeholder = Cons_Comment
                txtComment.frame = CGRect.init(x: imgvProfile.frame.maxX + 6, y: (55/2) - 17, width: viewComment.frame.width - (imgvProfile.frame.maxX + 12), height: 35)
                
                let btnComment : UIButton = UIButton.init(frame: CGRect.init(x: txtComment.frame.origin.x, y: txtComment.frame.origin.y, width: txtComment.frame.width, height: txtComment.frame.height))
                btnComment.setTitle("", for: UIControl.State.normal)
                btnComment.backgroundColor = UIColor.clear
                btnComment.addTarget(self, action: #selector(btnKeyboardTap(sender:)), for: UIControl.Event.touchUpInside)
                
                viewTitle.addSubview(viewComment)
                viewComment.addSubview(imgvProfile)
                viewComment.addSubview(txtComment)
                viewComment.addSubview(btnComment)
                
                viewSortBy.addTarget(self, action:#selector(btnSortByTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
        }else{
            if(section == 0) //Video Description
            {
                return UIView.init()
            }
            else if(section == 1)
            {
                return UIView.init()
            }
            else if(section == 2) // Recommended Videos
            {
                //Video List Header
                let viewTitle:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                viewTitle.backgroundColor = UIColor.white
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 16, y: 16, width: 200, height: 18))
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 18.0)
                lblTitle.textColor = UIColor.textColor_black
                lblTitle.text = Cons_Recommended_Videos
                
                viewTitle.addSubview(lblTitle)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
            else if(section == 3)
            {
                return UIView.init()
            }
            else
            {
                //Comment List Header
                let viewTitle:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 115))
                viewTitle.backgroundColor = UIColor.white
                
                let viewSeprator:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
                viewSeprator.backgroundColor = UIColor.seperator_color
                
                let lblTitle:UILabel = UILabel.init(frame: CGRect.init(x: 17, y: 8, width: UIScreen.main.bounds.width - 114, height: 22))
                lblTitle.font = UIFont.init(name: FontFamily.medium, size: 18.0)
                lblTitle.textColor = UIColor.textColor_black
                lblTitle.text = "\(self.modelVideoDetailData?.comment_count ?? 0) Comments"
                
                let viewSortBy:UIControl = UIControl.init(frame: CGRect.init(x: lblTitle.frame.maxX + 10, y: 8, width: 70, height: 22))
                
                let lblSortBy:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 22))
                lblSortBy.font = UIFont.init(name: FontFamily.medium, size: 13.0)
                lblSortBy.textColor = UIColor.theme_green
                lblSortBy.text = Cons_Sort_by
                lblSortBy.textAlignment = .center
                
                let imgView:UIImageView = UIImageView.init(frame: CGRect.init(x: lblSortBy.frame.maxX + 5, y: 6, width: 10, height: 10))
                imgView.contentMode = .scaleAspectFit
                imgView.image = UIImage.init(named: "down_arrow_green")
                
                viewTitle.addSubview(viewSeprator)
                viewTitle.addSubview(lblTitle)
                viewTitle.addSubview(viewSortBy)
                viewSortBy.addSubview(lblSortBy)
                viewSortBy.addSubview(imgView)
                
                let viewComment = UIView.init(frame:CGRect.init(x: 17, y:lblTitle.frame.maxY + 15, width: UIScreen.main.bounds.width - 34, height: 55))
                viewComment.backgroundColor = UIColor.seperator_color
                
                let imgvProfile:UIImageView = UIImageView.init()
                imgvProfile.frame = CGRect.init(x: 6, y:(55/2) - 18, width: 36, height: 36)
                imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                //imgvProfile.backgroundColor = UIColor.red
                imgvProfile.clipsToBounds = true
                
                if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                    imgvProfile.frame = CGRect(x: 6.0, y:(55/2) - 12, width: 24.0, height: 24.0)
                    imgvProfile.image = UIImage.init(named: Cons_Profile_Image_Name)
                    imgvProfile.contentMode = .scaleAspectFit
                    imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                    imgvProfile.clipsToBounds = true
                }else{
                    let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String
                    if self.verifyUrl(urlString: profileURL){
                        imgvProfile.frame = CGRect(x: 6.0, y:(55/2) - 18, width: 36.0, height: 36.0)
                        loadImageWith(imgView: imgvProfile, url: profileURL)
                        imgvProfile.contentMode = .scaleAspectFill
                        imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                        imgvProfile.clipsToBounds = true
                    }else{
                        imgvProfile.frame = CGRect(x: 6.0, y: (55/2) - 12, width: 24.0, height: 24.0)
                        imgvProfile.image = UIImage(named: Cons_Profile_Image_Name)
                        imgvProfile.contentMode = .scaleAspectFit
                        imgvProfile.layer.cornerRadius = imgvProfile.frame.height / 2
                        imgvProfile.clipsToBounds = true
                    }
                }
                
                let txtComment:UITextField = UITextField.init()
                txtComment.backgroundColor = UIColor.white
                txtComment.layer.cornerRadius = 3
                txtComment.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtComment.frame.height))
                txtComment.leftViewMode = .always
                txtComment.font = UIFont.init(name: FontFamily.medium, size: 12.0)
                txtComment.textColor = UIColor.textColor_gray
                txtComment.autocorrectionType = .no
                
                txtComment.placeholder = Cons_Comment
                txtComment.frame = CGRect.init(x: imgvProfile.frame.maxX + 6, y: (55/2) - 17, width: viewComment.frame.width - (imgvProfile.frame.maxX + 12), height: 35)
                
                let btnComment : UIButton = UIButton.init(frame: CGRect.init(x: txtComment.frame.origin.x, y: txtComment.frame.origin.y, width: txtComment.frame.width, height: txtComment.frame.height))
                btnComment.setTitle("", for: UIControl.State.normal)
                btnComment.backgroundColor = UIColor.clear
                btnComment.addTarget(self, action: #selector(btnKeyboardTap(sender:)), for: UIControl.Event.touchUpInside)
                
                viewTitle.addSubview(viewComment)
                viewComment.addSubview(imgvProfile)
                viewComment.addSubview(txtComment)
                viewComment.addSubview(btnComment)
                
                viewSortBy.addTarget(self, action:#selector(btnSortByTap), for: .touchUpInside)
                viewTitle.clipsToBounds = true
                return viewTitle
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if isFromPlaylist{
            if(indexPath.section == 0) //Video Description
            {
                let cell:VideoDetailsCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsCell", for: indexPath) as! VideoDetailsCell
                cell.modelVideoDetailData = self.modelVideoDetailData
                cell.btnExpand.tag = indexPath.row
                cell.btnExpand.addTarget(self, action: #selector(btnExpandTap(sender:)), for: .touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnUserProfileTap), for: .touchUpInside)
                cell.btnLike.addTarget(self, action: #selector(btnLikeTap(sender:)), for: .touchUpInside)
                cell.btnDisLike.addTarget(self, action: #selector(btnDisLikeTap(sender:)), for: .touchUpInside)
                cell.btnShare.addTarget(self, action: #selector(btnShareTap), for: .touchUpInside)
                cell.btnFollow.addTarget(self, action: #selector(btnFollowTap(sender:)), for: .touchUpInside)
                
                cell.strSelectedVideoId = self.strSelectedVideoId
                cell.strAddToStashType = AddToStash_TYPE.VideoDetail
                
                //AutoPlay Switch
                //                cell.lblAutoPlay.isHidden = false
                //                cell.swtchAutoPlay.isHidden = false
                cell.swtchAutoPlay.tag = indexPath.row
                cell.swtchAutoPlay.addTarget(self, action: #selector(actionSwitchAutoPlay(sender:)), for: .valueChanged)
                let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
                if autoPlaySwitch != ""{
                    if autoPlaySwitch == "true"{
                        cell.swtchAutoPlay.isOn = true
                    }
                    else{
                        cell.swtchAutoPlay.isOn = false
                    }
                }
                
                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap
                        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else if index == 1{ //1 => Add To Playlist tap
                        // Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else{
                        //Share
                    }
                })
                
                return cell
            }
            else if(indexPath.section == 1)
            {
                //return UITableViewCell()
                let addCell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
                self.loadMopubAdForVideoDetail_300(inView: addCell.viewAd)
                return addCell
            }
            else if (indexPath.section == 2) // Playlist Videos
            {
                let cell:VideoPlaylistCell = tableView.dequeueReusableCell(withIdentifier: "VideoPlaylistCell", for: indexPath) as! VideoPlaylistCell
                cell.objModelPlaylist = self.aryPlaylistVideos[indexPath.row]
                
                //For selected cell display with play icon
                if selectedIndexPathForPlay != nil && indexPath.row == self.indexOfPlaylist { //selectedIndexPathForPlay
                    cell.imgVideoPlay.isHidden = false
                    cell.lblVideoCount.isHidden = true
                }
                else{
                    cell.imgVideoPlay.isHidden = true
                    cell.lblVideoCount.isHidden = false
                }
                
                cell.strSelectedVideoId = self.aryPlaylistVideos[indexPath.row].uuid ?? ""
                cell.strAddToStashType = AddToStash_TYPE.VideoDetailPlaylist
                
                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap
                        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else if index == 1{ //1 => Add To Playlist tap
                        // Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else{
                        //Share
                    }
                })
                
                return cell
            }
            else if(indexPath.section == 3) // Recommended Videos
            {
                let cell:VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
                cell.modelVideoData = self.aryRecommendedVideos[indexPath.row]
                
                cell.strSelectedVideoId = self.aryRecommendedVideos[indexPath.row].video_uuid!
                cell.strAddToStashType = AddToStash_TYPE.VideoDetail
                
                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap
                        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else if index == 1{ //1 => Add To Playlist tap
                        // Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else{
                        //Share
                    }
                })
                return cell
            }
            else if(indexPath.section == 4)
            {
                //return UITableViewCell()
                let addCell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
                self.loadMopubAdForVideoDetail_300(inView: addCell.viewAd)
                return addCell
            }
            else
            {
                let cell:VideoCommentCell = tableView.dequeueReusableCell(withIdentifier: "VideoCommentCell", for: indexPath) as! VideoCommentCell
                cell.modelCommentListingData = self.aryVideoComments[indexPath.row]
                
                cell.btnCommentMore.tag = indexPath.row
                cell.btnCommentLike.tag = indexPath.row
                cell.btnCommentDisLike.tag = indexPath.row
                cell.btnCommentReply.tag = indexPath.row
                cell.cntrlProfile.tag = indexPath.row
                cell.btnReply.tag = indexPath.row
                cell.btnCommentMore.addTarget(self, action: #selector(btnCommentMoreTap(sender:)), for:.touchUpInside)
                cell.btnCommentLike.addTarget(self, action: #selector(btnCommentLikeTap(sender:)), for:.touchUpInside)
                cell.btnCommentDisLike.addTarget(self, action: #selector(btnCommentDisLikeTap(sender:)), for:.touchUpInside)
                cell.btnCommentReply.addTarget(self, action: #selector(btnReplyCommentTap(sender:)), for:.touchUpInside)
                cell.cntrlProfile.addTarget(self, action: #selector(btnProfileTap(sender:)), for:.touchUpInside)
                cell.btnReply.addTarget(self, action: #selector(btnReplyTap(sender:)), for:.touchUpInside)
                
                
                return cell
            }
        }
        else{
            if(indexPath.section == 0) //Video Description
            {
                let cell:VideoDetailsCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsCell", for: indexPath) as! VideoDetailsCell
                cell.modelVideoDetailData = self.modelVideoDetailData
                cell.btnExpand.tag = indexPath.row
                cell.btnExpand.addTarget(self, action: #selector(btnExpandTap(sender:)), for: .touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnUserProfileTap), for: .touchUpInside)
                cell.btnLike.addTarget(self, action: #selector(btnLikeTap(sender:)), for: .touchUpInside)
                cell.btnDisLike.addTarget(self, action: #selector(btnDisLikeTap(sender:)), for: .touchUpInside)
                cell.btnShare.addTarget(self, action: #selector(btnShareTap), for: .touchUpInside)
                cell.btnFollow.addTarget(self, action: #selector(btnFollowTap(sender:)), for: .touchUpInside)
                
                cell.strSelectedVideoId = self.strSelectedVideoId
                cell.strAddToStashType = AddToStash_TYPE.VideoDetail
                
                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap
                        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else if index == 1{ //1 => Add To Playlist tap
                        // Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else{
                        //Share
                    }
                })
                
                //AutoPlay Switch
                //                cell.lblAutoPlay.isHidden = false
                //                cell.swtchAutoPlay.isHidden = false
                cell.swtchAutoPlay.tag = indexPath.row
                cell.swtchAutoPlay.addTarget(self, action: #selector(actionSwitchAutoPlay(sender:)), for: .valueChanged)
                let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
                if autoPlaySwitch != ""{
                    if autoPlaySwitch == "true"{
                        cell.swtchAutoPlay.isOn = true
                    }
                    else{
                        cell.swtchAutoPlay.isOn = false
                    }
                }
                return cell
            }
            else if(indexPath.section == 1)
            {
                //return UITableViewCell()
                let addCell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
                self.loadMopubAdForVideoDetail_300(inView: addCell.viewAd)
                return addCell
            }
            else if(indexPath.section == 2) // Recommended Videos
            {
                let cell:VideoListCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
                cell.modelVideoData = self.aryRecommendedVideos[indexPath.row]
                
                cell.strSelectedVideoId = self.aryRecommendedVideos[indexPath.row].video_uuid!
                cell.strAddToStashType = AddToStash_TYPE.VideoDetail
                
                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap
                        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else if index == 1{ //1 => Add To Playlist tap
                        // Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else{
                        //Share
                    }
                })
                return cell
            }
            else if(indexPath.section == 3)
            {
                //return UITableViewCell()
                let addCell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
                self.loadMopubAdForVideoDetail_300(inView: addCell.viewAd)
                return addCell
            }
            else
            {
                let cell:VideoCommentCell = tableView.dequeueReusableCell(withIdentifier: "VideoCommentCell", for: indexPath) as! VideoCommentCell
                cell.modelCommentListingData = self.aryVideoComments[indexPath.row]
                
                cell.btnCommentMore.tag = indexPath.row
                cell.btnCommentLike.tag = indexPath.row
                cell.btnCommentDisLike.tag = indexPath.row
                cell.btnCommentReply.tag = indexPath.row
                cell.cntrlProfile.tag = indexPath.row
                cell.btnReply.tag = indexPath.row
                cell.btnCommentMore.addTarget(self, action: #selector(btnCommentMoreTap(sender:)), for:.touchUpInside)
                cell.btnCommentLike.addTarget(self, action: #selector(btnCommentLikeTap(sender:)), for:.touchUpInside)
                cell.btnCommentDisLike.addTarget(self, action: #selector(btnCommentDisLikeTap(sender:)), for:.touchUpInside)
                cell.btnCommentReply.addTarget(self, action: #selector(btnReplyCommentTap(sender:)), for:.touchUpInside)
                cell.cntrlProfile.addTarget(self, action: #selector(btnProfileTap(sender:)), for:.touchUpInside)
                cell.btnReply.addTarget(self, action: #selector(btnReplyTap(sender:)), for:.touchUpInside)
                
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        
        if isFromPlaylist{
            if (indexPath.section == 0){//VideoDetailCell
                if indexPath.section == selectedIndxCategory && cellCategoryTapped{
                    let height = expandHeight + 221.0
                    return height
                }else{
                    return 221.0
                }
            }
            else if(indexPath.section == 1){
                return 320.0
            }
            else if(indexPath.section == 2){//PlaylistCell
                if indexPath.section == selectedIndx && cellTapped{
                    return 81.0
                }else{
                    return 0
                }
            }
            else if(indexPath.section == 3){//VideoListCell
                return 104.0
            }
            else if(indexPath.section == 4){//VideoListCell
                return 70.0
            }
            else{//VideoCommentCell
                //return 153
                return UITableView.automaticDimension
            }
        }else{
            if (indexPath.section == 0){//VideoDetailCell
                if indexPath.section == selectedIndxCategory && cellCategoryTapped{
                    let height = expandHeight + 221.0
                    return height
                }else{
                    return 221.0
                }
            }
            else if(indexPath.section == 1){//VideoListCell
                return 320.0
            }
            else if(indexPath.section == 2){//VideoListCell
                return 104.0
            }
            else if(indexPath.section == 3){//VideoListCell
                return 70.0
            }
            else{//VideoCommentCell
                //return 153
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if isFromPlaylist{
            if (indexPath.section == 2) // Playlist Videos
            {
                self.selectedIndexPathForPlay = indexPath
                self.indexOfPlaylist = indexPath.row
                self.strSelectedVideoId = self.aryPlaylistVideos[indexPath.row].uuid ?? ""
                //self.tblvVideoDetail.setContentOffset(.zero, animated: false)
                self.initialSetup()
                self.jwPlayer.fullscreen = false
            }
            else if(indexPath.section == 3) // Recommended Videos
            { //VideoListCell - Recommended
                let modelVideoData = self.aryRecommendedVideos[indexPath.row]
                self.strSelectedVideoId = modelVideoData.video_uuid ?? ""
                //self.tblvVideoDetail.setContentOffset(.zero, animated: false)
                self.initialSetup()
                self.jwPlayer.fullscreen = false
            }
        }
        else{
            if(indexPath.section == 2) // Recommended Videos
            { //VideoListCell - Recommended
                let modelVideoData = self.aryRecommendedVideos[indexPath.row]
                self.strSelectedVideoId = modelVideoData.video_uuid ?? ""
                //self.tblvVideoDetail.setContentOffset(.zero, animated: false)
                self.initialSetup()
                self.jwPlayer.fullscreen = false
            }
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnDownArrowTap(_ sender: UIButton){
        //        self.dismiss(animated: true, completion: nil)
        GLOBAL.sharedInstance.isAdTapped = false
        self.jwPlayer.pause()
        self.jwPlayer = JWPlayerController()
        self.jwPlayer.fullscreen = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_NAME.On_Add_Clicked), object: nil)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.popVCWithDismisAnimation()
    }
    
    @objc func actionSwitchAutoPlay(sender: PVSwitch) {
        if sender.isOn{
            DefaultValue.shared.setStringValue(value: "true", key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        }else{
            DefaultValue.shared.setStringValue(value: "false", key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        }
    }
    
}

//MARK:- Video Detail Section Events
extension VideoDetailVC{
    @objc func btnUserProfileTap(){
        
        self.jwPlayer.pause()
        
        let user_uuid = self.modelVideoDetailData?.user_uuid ?? ""
        if user_uuid == ""{
            
        }
        else{
            if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                self.toProfile(isForOwn: false, uuid: user_uuid)
            }else{
                let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as! String
                if strUserUUID == user_uuid{
                    self.toProfile(isForOwn: true, uuid: user_uuid)
                }else{
                    self.toProfile(isForOwn: false, uuid: user_uuid)
                }
            }
            
            
        }
    }
    
    func toProfile(isForOwn:Bool,uuid:String){
        self.jwPlayer.pause()
        let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
        profileVC.hidesBottomBarWhenPushed = true
        profileVC.user_uuid = uuid
        profileVC.isForOwnProfile = isForOwn
        let topNavigationVC = UIApplication.topViewController()
        topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func btnLikeTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_Like_Video, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let indexPath = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
            
            if(indexPath.section == 0){
                
                let strLikeStatus = "Yes"
                
                GLOBAL.sharedInstance.callVideoLikeUnlikeAPI(strVideoUUID: strSelectedVideoId, strIsLike: strLikeStatus, isInMainThread: true,completionBlock: { (status, message) in
                    
                    //self.alertOnTop(message: message)
                    //self.showToastMessage(title: message)
                    
                    if(status){
                        //Updating cell after successful api call...
                        let cell = self.tblvVideoDetail.cellForRow(at: indexPath) as! VideoDetailsCell
                        if(self.modelVideoDetailData?.is_like?.lowercased() == "yes"){
                            self.modelVideoDetailData?.is_like = ""
                            self.modelVideoDetailData?.like_count = (self.modelVideoDetailData?.like_count ?? 0) - 1
                        }
                        else if(self.modelVideoDetailData?.is_like?.lowercased() == "no"){ //DisLike selected
                            self.modelVideoDetailData?.is_like = "Yes"
                            self.modelVideoDetailData?.like_count = (self.modelVideoDetailData?.like_count ?? 0) + 1
                            self.modelVideoDetailData?.dislike_count = (self.modelVideoDetailData?.dislike_count ?? 0) - 1
                        }
                        else{
                            self.modelVideoDetailData?.is_like = "Yes"
                            self.modelVideoDetailData?.like_count = (self.modelVideoDetailData?.like_count ?? 0) + 1
                        }
                        cell.updateLikeDislikeSelection()
                        //-----------------------------------------
                    }
                })
            }
        }
        
    }
    
    @objc func btnDisLikeTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_DisLike_Video, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let indexPath = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
            if(indexPath.section == 0){
                
                let strLikeStatus = "No"
                
                GLOBAL.sharedInstance.callVideoLikeUnlikeAPI(strVideoUUID: strSelectedVideoId, strIsLike: strLikeStatus, isInMainThread: true,completionBlock: { (status, message) in
                    
                    //self.alertOnTop(message: message)
                    //self.showToastMessage(title: message)
                    
                    if(status){
                        //Updating cell after successful api call...
                        let cell = self.tblvVideoDetail.cellForRow(at: indexPath) as! VideoDetailsCell
                        if(self.modelVideoDetailData?.is_like?.lowercased() == "yes"){
                            self.modelVideoDetailData?.is_like = "No"
                            self.modelVideoDetailData?.like_count = (self.modelVideoDetailData?.like_count ?? 0) - 1
                            self.modelVideoDetailData?.dislike_count = (self.modelVideoDetailData?.dislike_count ?? 0) + 1
                        }
                        else if(self.modelVideoDetailData?.is_like?.lowercased() == "no"){ //DisLike selected
                            self.modelVideoDetailData?.is_like = ""
                            self.modelVideoDetailData?.dislike_count = (self.modelVideoDetailData?.dislike_count ?? 0) - 1
                        }
                        else{
                            self.modelVideoDetailData?.is_like = "No"
                            self.modelVideoDetailData?.dislike_count = (self.modelVideoDetailData?.dislike_count ?? 0) + 1
                        }
                        cell.updateLikeDislikeSelection()
                        //-----------------------------------------
                    }
                })
            }
        }
    }
    
    @objc func btnShareTap(){
        
        let videoName = self.modelVideoDetailData?.title ?? Share_Url
        let videoUrl = self.modelVideoDetailData?.video_web_url ?? Share_Url
        
        let strShare = """
        \(App_Name)\n
        \(videoName)\n
        \(videoUrl)
        """
        
        GLOBAL.sharedInstance.openSharingIndicator(url: strShare) {
        }
    }
    
    @objc func btnFollowTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_VideoDetail, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            
            let indexPath = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
            if(indexPath.section == 0){
                
                let strFollowUnFollowStatus = self.modelVideoDetailData?.is_follow?.lowercased() == "yes" ? "0" : "1"
                let strUserUUID = self.modelVideoDetailData?.user_uuid ?? ""
                
                GLOBAL.sharedInstance.callFollowUpfollowAPI(strFollowingID: strUserUUID, strIsFollowUnFollow: strFollowUnFollowStatus, isInMainThread: true,completionBlock: { (status, message) in
                    
                    //self.showToastMessage(title: message)
                    
                    if(status){
                        self.alertOnTop(message: message, style: .success)
                        //Updating cell after successful api call...
                        self.modelVideoDetailData?.is_follow = self.modelVideoDetailData?.is_follow?.lowercased() == "yes" ? "No" : "Yes"
                        let cell = self.tblvVideoDetail.cellForRow(at: indexPath) as! VideoDetailsCell
                        cell.updateFollowButtonUI()
                        //-----------------------------------------
                    }
                })
            }
        }
    }
}

//MARK:- Playlist Section Events
extension VideoDetailVC{
    @objc func btnViewMorePlaylistTap(sender:UIButton){
        self.callGetPlaylistVideoAPI(playlistId: self.strPlaylistVideoId)
    }
    
    @objc func btnExpandPlaylistTap(sender:UIButton){
        //print("selected index",sender.tag)
        
        if selectedIndx != sender.tag {
            self.cellTapped = true
            self.selectedIndx = sender.tag
            DispatchQueue.main.async {
                self.topHeaderView.btnExpand.setImage(UIImage.init(named: "up_arrow"), for: UIControl.State.normal)
            }
        }
        else {
            // there is no cell selected anymore
            self.cellTapped = false
            self.selectedIndx = -1
            DispatchQueue.main.async {
                self.topHeaderView.btnExpand.setImage(UIImage.init(named: "down_arrow_detail"), for: UIControl.State.normal)
            }
        }
        tblvVideoDetail.reloadData()
    }
}

//MARK:- Video List Section Events
extension VideoDetailVC{
    @objc func btnViewMoreVideoTap(sender:UIControl){
        self.callGetRecommendedVideoAPI()
    }
}

//MARK:- Comment List Section Events
extension VideoDetailVC{
    @objc func btnCommentLikeTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_Like, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let indexPath = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
            if(indexPath.section == 2){
                
                let modelCommentListingData : Model_CommentListingData? = self.aryVideoComments[indexPath.row]
                
                let strLikeStatus = "Yes"
                
                GLOBAL.sharedInstance.callVideoCommentLikeUnlikeAPI(strCommentUUID: modelCommentListingData?.comment_uuid ?? "", strIsLike: strLikeStatus, strApiName: APIName.VideoCommentLikeUnlike, isInMainThread: true,completionBlock: { (status, message) in
                    
                    //self.alertOnTop(message: message)
                    //self.showToastMessage(title: message)
                    
                    if(status){
                        //Updating cell after successful api call...
                        let cell = self.tblvVideoDetail.cellForRow(at: indexPath) as! VideoCommentCell
                        if(modelCommentListingData?.is_like?.lowercased() == "yes"){
                            modelCommentListingData?.is_like = ""
                            modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! - 1)
                        }
                        else if(modelCommentListingData?.is_like?.lowercased() == "no"){ //DisLike selected
                            modelCommentListingData?.is_like = "Yes"
                            modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! + 1)
                            modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! - 1)
                        }
                        else{
                            modelCommentListingData?.is_like = "Yes"
                            modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! + 1)
                        }
                        cell.updateLikeDislikeSelection()
                        //-----------------------------------------
                    }
                })
            }
        }
    }
    
    @objc func btnCommentDisLikeTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_DisLike, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let indexPath = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
            if(indexPath.section == 2){
                
                let modelCommentListingData : Model_CommentListingData? = self.aryVideoComments[indexPath.row]
                let strLikeStatus = "No"
                
                GLOBAL.sharedInstance.callVideoCommentLikeUnlikeAPI(strCommentUUID: modelCommentListingData?.comment_uuid ?? "", strIsLike: strLikeStatus, strApiName: APIName.VideoCommentLikeUnlike, isInMainThread: true,completionBlock: { (status, message) in
                    
                    //self.alertOnTop(message: message)
                    //self.showToastMessage(title: message)
                    
                    if(status){
                        //Updating cell after successful api call...
                        let cell = self.tblvVideoDetail.cellForRow(at: indexPath) as! VideoCommentCell
                        if(modelCommentListingData?.is_like?.lowercased() == "yes"){
                            modelCommentListingData?.is_like = "No"
                            modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! - 1)
                            modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! + 1)
                        }
                        else if(modelCommentListingData?.is_like?.lowercased() == "no"){ //DisLike selected
                            modelCommentListingData?.is_like = ""
                            modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! - 1)
                        }
                        else{
                            modelCommentListingData?.is_like = "No"
                            modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! + 1)
                        }
                        cell.updateLikeDislikeSelection()
                        //-----------------------------------------
                    }
                })
            }
        }
    }
    
    @objc func btnViewMoreCommentTap(){
        self.callGetVideoCommentsListAPI(sortType: "", strStart: String(self.aryVideoComments.count), strSortParam: Cons_Created_at, isFromViewMore: true)
    }
    
    @objc func btnSortByTap(){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_NonLogin_message, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            DispatchQueue.main.async {
                
                let viewSortBy = Bundle.loadView(fromNib: "SortByView", withType: SortByView.self)
                viewSortBy.frame = UIScreen.main.bounds
                viewSortBy.selectedIndexPath = self.selectedIndexPath
                
                viewSortBy.addSubviewWithAnimationBottom(animation: {
                }, completion: {
                })
                
                //Callback
                viewSortBy.handler = CompletionHandlerBlockSortBy({index,strTitle,indexpath  in
                    //print("\n title: \(strTitle) , strId: \(indexpath) \n")
                    
                    self.selectedIndexPath = indexpath
                    var strSortType = ""
                    var strSortParam = ""
                    if strTitle == SortBy.Oldest{
                        strSortType = Cons_ASC
                        strSortParam = Cons_Created_at
                    }else if strTitle == SortBy.MostLiked{
                        //Most Liked
                        strSortType = Cons_DESC
                        strSortParam = Cons_like_count
                    }else{
                        //Newest
                        strSortType = Cons_DESC
                        strSortParam = Cons_Created_at
                    }
                    self.callGetVideoCommentsListAPI(sortType: strSortType, strStart: "0", strSortParam: strSortParam, isFromViewMore: true)
                    
                })
            }
        }
    }
    
    @objc func btnProfileTap(sender:UIControl){
        
        self.jwPlayer.pause()
        
        let objCmnt = self.aryVideoComments[sender.tag]
        let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
        let strUserID = objCmnt.user_uuid ?? ""
        if strUserUUID != nil{
            //not allowed for own profile
            if strUserID != ""{ //(strUserUUID as! String) != strUserID &&
                if strUserID == (strUserUUID as! String){
                    self.redirectToProfileScreen(isForOwn: true, strUserID: strUserID)
                }
                else{
                    self.redirectToProfileScreen(isForOwn: false, strUserID: strUserID)
                }
            }
        }else{
            if strUserID != ""{
                self.redirectToProfileScreen(isForOwn: false, strUserID: strUserID)
            }
        }
    }
    
    func redirectToProfileScreen(isForOwn: Bool,strUserID:String){
        let viewController = UIStoryboard.init(name: ("Main"), bundle: nil).instantiateViewController(withIdentifier: "ProfileMainVC") as! ProfileMainVC
        viewController.hidesBottomBarWhenPushed = true
        viewController.user_uuid = strUserID
        viewController.isForOwnProfile = isForOwn
        let topNavigationVC = UIApplication.topViewController()
        topNavigationVC?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func openCommentPopUp(_ sender: UIButton) {
        //Comment pop up
        self.view.endEditing(true)
        
        let indexPath = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
        self.viewComments.modelCommentListingData = self.aryVideoComments[indexPath.row]
        self.viewComments.setupUI()
        
        UIView.animate(withDuration: 0.6, animations: {
            self.viewComments.frame = CGRect.init(x: 0, y: (self.viewVideo.frame.maxY + 20), width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) - (self.viewVideo.frame.maxY + 20) )
            self.view.addSubview(self.viewComments)
            //UIApplication.shared.keyWindow?.addSubview(self.viewComments)
        }) { (result : Bool) in
            
            if self.isFromViewReplies == false{
                self.viewComments.setUpKeyboard(sender: sender, "", KeyboardEvent.AddReply.rawValue)
                //keyboard open with username for comment
                let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
                if strUserUUID != nil{
                    if (strUserUUID as! String) != self.aryVideoComments[sender.tag].user_uuid ?? ""{
                        //self.viewComments.strUsername = self.aryVideoComments[sender.tag].user_name ?? ""
                        self.viewComments.isFromComment = true
                    }
                }else{
                    //self.viewComments.strUsername = ""
                    self.viewComments.isFromComment = false
                }
            }else{
                
            }
        }
        
        self.viewComments.handler = CompletionHandlerBlockComment({(index,title,uuid) in
            //print("\n title: \(title) , uuid: \(uuid) \n")
            
            if(index == 999){
                self.aryVideoComments.remove(at: indexPath.row)
            }
            else if index == 1000{
                
            }
            self.tblvVideoDetail.reloadData()
        })
    }
    
    @objc func btnReplyTap(sender:UIButton){
        isFromViewReplies = true
        openCommentPopUp(sender)
        
    }
    
    
    @objc func btnReplyCommentTap(sender:UIButton){
        isFromViewReplies = false
        openCommentPopUp(sender)
    }
    
}

//MARK:- Expand Category Methods
extension VideoDetailVC{
    @objc func btnExpandTap(sender:UIButton){
        let cell:VideoDetailsCell = tblvVideoDetail.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! VideoDetailsCell
        //For webview
        //        if(cell.constraintWebHeight.constant != 0){
        //            cell.constraintWebHeight.constant = 0
        //        }
        //        else{
        //            cell.constraintWebHeight.constant = CGFloat(cell.heightForWebView)
        //        }
        
        if selectedIndxCategory != sender.tag {
            self.cellCategoryTapped = true
            self.selectedIndxCategory = sender.tag
            cell.conHeight.constant = CGFloat(cell.viewCategory.frame.maxY + 15)
            cell.btnExpand.setImage(UIImage.init(named: "up_arrow"), for: UIControl.State.normal)
            expandHeight = CGFloat(cell.viewCategory.frame.maxY + 15)
        }
        else {
            // there is no cell selected anymore
            self.cellCategoryTapped = false
            self.selectedIndxCategory = -1
            cell.conHeight.constant = 0
            cell.btnExpand.setImage(UIImage.init(named: "down_arrow_detail"), for: UIControl.State.normal)
            expandHeight = 0
        }
        tblvVideoDetail.reloadData()
        
        //        if(cell.conHeight.constant != 0){
        //            cell.conHeight.constant = 0
        //        }
        //        else{
        //            cell.conHeight.constant = CGFloat(cell.viewCategory.frame.maxY + 15)
        //        }
        //        tblvVideoDetail.reloadData()
        //        tblvVideoDetail.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
    }
}

//MARK:- Report Actionsheet Methods
extension VideoDetailVC{
    
    @IBAction func btnTopbarMoreTap(sender:UIControl){
        
        DispatchQueue.main.async {
            
            //Callback
            self.handler = indexHandlerBlock({(index) in
                if index == 0{ //0 => Report
                    if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                        Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Report, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                            switch(index){
                            case 1:
                                self.jwPlayer.pause()
                                self.redirctToLoginScreen()
                            default:
                                print("Cancel tapped")
                            }
                        })
                    }else{
                        GLOBAL.sharedInstance.callReportcategorylistAPI(isInMainThread: true, completionBlock: { (status, message) in
                            
                            let viewReportVideoPopup = Bundle.loadView(fromNib: "ReportVideoPopup", withType: ReportVideoPopup.self)
                            viewReportVideoPopup.frame = UIScreen.main.bounds
                            viewReportVideoPopup.viewMain.backgroundColor = .clear
                            viewReportVideoPopup.strSelectedVideoId = self.strSelectedVideoId
                            viewReportVideoPopup.addSubviewWithAnimationCenter(animation: {
                            }) {//Completion
                                
                                if(GLOBAL.sharedInstance.arrayReportCategoryData.count > 0){
                                    let modelReportCategoryData = GLOBAL.sharedInstance.arrayReportCategoryData[0]
                                    viewReportVideoPopup.txtCategory.txtField.text = modelReportCategoryData.title ?? ""
                                    viewReportVideoPopup.strReportCategoryUUID = modelReportCategoryData.uuid ?? ""
                                }
                            }
                        })
                    }
                    
                }else { //1 => Quality
                    //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                }
            })
            
            
            let viewAddStash = Bundle.loadView(fromNib: "ReportActionSheet", withType: ReportActionSheet.self)
            viewAddStash.frame = UIScreen.main.bounds
            viewAddStash.strPopUpTYPE = PopUpType.ReportActionSheet
            viewAddStash.setupPopUpUI()
            if(self.handler != nil){
                viewAddStash.handler = self.handler
            }
            //SMP:Change
            //viewAddStash.viewMain.backgroundColor = .clear
            viewAddStash.addSubviewWithAnimationBottom(animation: {
            }, completion: {
                //viewAddStash.viewMain.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
            })
        }
    }
}

//MARK:- Comment Edit Delete Methods
extension VideoDetailVC{
    @objc func btnCommentMoreTap(sender:UIButton){
        let tappedButtonIndex = self.indexPathForControl(sender, tableView: self.tblvVideoDetail)
        //print("\(tappedButtonIndex.row)" + " " + "\(tappedButtonIndex.section)")
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_NonLogin_message, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.jwPlayer.pause()
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
            if strUserUUID != nil{
                if (strUserUUID as! String) == self.aryVideoComments[tappedButtonIndex.row].user_uuid ?? ""{
                    //        if let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as? String{
                    //            if strUserUUID == self.aryVideoComments[tappedButtonIndex.row].user_uuid{
                    DispatchQueue.main.async {//Edit delete comment
                        
                        let viewComment = Bundle.loadView(fromNib: "ReportActionSheet", withType: ReportActionSheet.self)
                        viewComment.frame = UIScreen.main.bounds
                        viewComment.strPopUpTYPE = PopUpType.CommentListOwn
                        viewComment.strCommentId = self.aryVideoComments[tappedButtonIndex.row].comment_uuid ?? ""
                        
                        viewComment.setupPopUpUI()
                        
                        viewComment.addSubviewWithAnimationBottom(animation: {
                        }, completion: {
                        })
                        
                        //Callback
                        viewComment.handlerBlock = CompletionHandler({index,status  in
                            if index == 102{ //0 => Edit
                                self.openKeyboardPopUp(tappedButtonIndex.row, self.aryVideoComments[tappedButtonIndex.row].comment ?? "", KeyboardEvent.EditComment.rawValue)
                            }else { //1 => Delete
                                //print("\n----------- status---------\n",status)
                                if status == Cons_Success{
                                    self.aryVideoComments.remove(at: tappedButtonIndex.row)
                                    
                                    var commentCount = self.modelVideoDetailData?.comment_count ?? 0
                                    commentCount = commentCount - 1
                                    self.modelVideoDetailData?.comment_count = commentCount
                                    
                                    self.tblvVideoDetail.reloadData()
                                }
                            }
                        })
                    }
                }
            }
            else{
                //Report pop up
                DispatchQueue.main.async {
                    
                    //Callback
                    self.handler = indexHandlerBlock({(index) in
                        if index == 0{ //0 => Report
                            if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                                Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Report, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                                    switch(index){
                                    case 1:
                                        self.jwPlayer.pause()
                                        self.redirctToLoginScreen()
                                    default:
                                        print("Cancel tapped")
                                    }
                                })
                            }else{
                                GLOBAL.sharedInstance.callReportcategorylistAPI(isInMainThread: true, completionBlock: { (status, message) in
                                    
                                    let viewReportVideoPopup = Bundle.loadView(fromNib: "ReportVideoPopup", withType: ReportVideoPopup.self)
                                    viewReportVideoPopup.frame = UIScreen.main.bounds
                                    viewReportVideoPopup.viewMain.backgroundColor = .clear
                                    viewReportVideoPopup.strSelectedVideoId = self.aryVideoComments[tappedButtonIndex.row].comment_uuid ?? ""
                                    viewReportVideoPopup.addSubviewWithAnimationCenter(animation: {
                                    }) {//Completion
                                        
                                        if(GLOBAL.sharedInstance.arrayReportCategoryData.count > 0){
                                            let modelReportCategoryData = GLOBAL.sharedInstance.arrayReportCategoryData[0]
                                            viewReportVideoPopup.txtCategory.txtField.text = modelReportCategoryData.title ?? ""
                                            viewReportVideoPopup.strReportCategoryUUID = modelReportCategoryData.uuid ?? ""
                                        }
                                    }
                                })
                            }
                            
                        }
                    })
                    
                    let viewAddStash = Bundle.loadView(fromNib: "ReportActionSheet", withType: ReportActionSheet.self)
                    viewAddStash.frame = UIScreen.main.bounds
                    viewAddStash.strPopUpTYPE = PopUpType.ReportOther
                    viewAddStash.setupPopUpUI()
                    if(self.handler != nil){
                        viewAddStash.handler = self.handler
                    }
                    //SMP:Change
                    //viewAddStash.viewMain.backgroundColor = .clear
                    viewAddStash.addSubviewWithAnimationBottom(animation: {
                    }, completion: {
                        //viewAddStash.viewMain.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
                    })
                }
            }
        }
    }
}

//MARK: - Keyboard Methods
extension VideoDetailVC{
    
    fileprivate func openKeyboardPopUp(_ sender: Int,_ txtComment: String, _ intKeyboardValue: Int) {
        self.view.endEditing(true)
        
        
        DispatchQueue.main.async {
            self.viewKeyboard.handler = CompletionHandlerKeyboard({(index,title) in
                //print("\n title: \(title)")
                
                if index == KeyboardEvent.AddComment.rawValue{//Add comment
                    //Send button
                    if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                        Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_Comment, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                            switch(index){
                            case 1:
                                self.jwPlayer.pause()
                                self.redirctToLoginScreen()
                            default:
                                print("Cancel tapped")
                            }
                        })
                    }else{
                        GLOBAL.sharedInstance.callVideoAddCommentAPI(strVideoUUID: self.strSelectedVideoId, strComment: title, isInMainThread: true,completionBlock: { (status, message, modelComment) in
                            
                            //self.alertOnTop(message: message)
                            
                            if(status && modelComment != nil){
                                self.alertOnTop(message: message, style: .success)
                                //Updating cell after successful api call...
                                self.aryVideoComments.insert(modelComment!, at: 0)
                                
                                var commentCount = self.modelVideoDetailData?.comment_count ?? 0
                                commentCount = commentCount + 1
                                self.modelVideoDetailData?.comment_count = commentCount
                                
                                self.tblvVideoDetail.reloadData()
                                //-----------------------------------------
                            }
                        })
                    }
                }
                else if index == KeyboardEvent.EditComment.rawValue{//Edit comment
                    let strCommentId = self.aryVideoComments[sender].comment_uuid ?? ""
                    let strComment = self.viewKeyboard.txtReply.text ?? ""
                    
                    GLOBAL.sharedInstance.callEditCommentAPI(strCommentID: strCommentId, strComment: strComment, isInMainThread: true,completionBlock: { (status, message,modelComment) in
                        
                        if(status){
                            self.alertOnTop(message: message, style: .success)
                            //Updating cell after successful api call...
                            //self.aryVideoComments.insert(modelComment!, at: 0)
                            
                            self.aryVideoComments[sender].comment = strComment
                            
                            self.tblvVideoDetail.reloadData()
                            //-----------------------------------------
                        }
                    })
                }
                
                self.viewKeyboard.txtReply.text = ""
                self.viewKeyboard.cntrlSend.isHidden = true
            })
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.viewKeyboard.frame = UIScreen.main.bounds
                self.viewKeyboard.keyboardEventVal = KeyboardEvent(rawValue: intKeyboardValue)!
                let keyboardType = KeyboardEvent(rawValue: intKeyboardValue)!
                if keyboardType.rawValue == KeyboardEvent.AddComment.rawValue{
                    self.viewKeyboard.txtReply.placeholder = Cons_Comment
                }else{
                    self.viewKeyboard.txtReply.text = txtComment + " "
                }
                self.viewKeyboard.setKeyboard()
                UIApplication.shared.keyWindow?.addSubview(self.viewKeyboard)
            }) { (result : Bool) in
                
            }
        }
    }
    
    @objc func btnKeyboardTap(sender:UIButton){
        
        //write a comment
        openKeyboardPopUp(sender.tag, "", KeyboardEvent.AddComment.rawValue)
        
    }
    
}

//MARK: - JWPlayer Setup Methods
extension VideoDetailVC : JWPlayerDelegate{
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func onFullscreenToggled(fullscreen: Bool) {
        
        if fullscreen{
            self.jwPlayer.forceLandscapeOnFullScreen = true
            self.jwPlayer.fullscreen = true
            self.jwPlayer.forceFullScreenOnLandscape = true
            
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
            
            self.tblvVideoDetail.isHidden = true
        }
        else{
            self.jwPlayer.forceLandscapeOnFullScreen = false
            self.jwPlayer.fullscreen = false
            self.jwPlayer.forceFullScreenOnLandscape = false
            
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            
            self.tblvVideoDetail.isHidden = false
        }
    }
    
    
    @objc func addClicked(_ notification: NSNotification){
        if notification.name.rawValue == NOTIFICATION_NAME.On_Add_Clicked{
            DispatchQueue.main.async {
                self.jwPlayer.play()
            }
            GLOBAL.sharedInstance.isAdTapped = false
            //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_NAME.On_Add_Clicked), object: nil)
        }
    }
    
    func setupJWPlayer(){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            // report for an error
        }
        
        //##### Play item setup #####
        self.addToPlaySingleVideo()
        self.addToPlaySingleVideoWithDifferentResolutin()
        //self.addItemsToJWPlaylist()
        
        //##### Config Setup #####
        //config.offlinePoster = UIImage.init(named: PLACEHOLDER_IMAGENAME.Large)
        //config.offlineMessage = "No connection"
        //config.title = "My Video Title"
        config.image = self.modelVideoDetailData?.thumbnail ?? ""
        config.controls = true  //default
        config.`repeat` = false   //default
        config.size = viewVideo.frame.size
        config.autostart = true
        
        config.stretching = JWStretching.none //JWStretchingExactFit //JWStretchingUniform //JWStretchingExactFit //JWStretchingFill //JWStretchingNone
        
        //##### Extra setup #####
        //self.setJWConfigTrackCaption()
        //self.setJWConfigCaptionStyling()
        self.setJWConfigAds()
        
        //##### JWPlayer control setup #####
        jwPlayer = JWPlayerController.init(config: config)
        jwPlayer.delegate = self
        
        jwPlayer.openSafariOnAdClick        = true
        jwPlayer.forceFullScreenOnLandscape = true
        jwPlayer.forceLandscapeOnFullScreen = true
        let frame: CGRect = self.viewVideo.bounds
        jwPlayer.view.frame = frame
        //        jwPlayer.view.autoresizingMask = [
        //            .flexibleBottomMargin,
        //            .flexibleHeight,
        //            .flexibleLeftMargin,
        //            .flexibleRightMargin,
        //            .flexibleTopMargin,
        //            .flexibleWidth]
        //        jwPlayer.view.frame = CGRect(x: 0, y: 0, width: viewVideo.frame.size.width, height: viewVideo.frame.size.height)
        
        viewVideo.addSubview(jwPlayer.view)
     
        
//        ////Sam////
//        jwPlayer.stop()
//        let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
//        if autoPlaySwitch != ""{
//            if autoPlaySwitch == "true"{
//                jwPlayer.play()
//            }
//            else{
//                jwPlayer.pause()
//            }
//        }
//        ////Sam////
        
        
        //##### JWPlayer Callback setup #####
        self.setupCallbacks()
    }
    
    
    @objc func btnPressed(sender: UIButton!) {
       
        print("pressed")
    }
    
    func setJWConfigTrackCaption(){
        //JWTrack (captions)
        config.tracks = [JWTrack (file: "http://playertest.longtailvideo.com/caption-files/sintel-en.srt", label: "English", isDefault: true),
                         JWTrack (file: "http://playertest.longtailvideo.com/caption-files/sintel-sp.srt", label: "Spanish"),
                         JWTrack (file: "http://playertest.longtailvideo.com/caption-files/sintel-ru.srt", label: "Russian")]
    }
    
    func setJWConfigCaptionStyling(){
        //JWCaptionStyling
        let captionStyling: JWCaptionStyling = JWCaptionStyling()
        captionStyling.font            = fontType.InterUI_Medium_24
        captionStyling.edgeStyle       = JWEdgeStyle.none
        captionStyling.windowColor     = .red
        captionStyling.backgroundColor = UIColor.clear //UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 0.7)
        captionStyling.color           = .yellow
        config.captions                = captionStyling
    }
    
    func setJWConfigAds(){
        //JWAdConfig
        let adConfig: JWAdConfig = JWAdConfig()
       
        adConfig.client = JWAdClient.vast
        
      
        adConfig.schedule = [
            
   //     JWAdBreak(tag: "http://playertest.longtailvideo.com/pre.xml", offset:"pre"),
            //https://aj1602.online/zSJh_CkVzsHYoep0YbMWOt6dDGNFOxSHENTXB4DJWByt7Z_nIot4qgXMTJT-5NuZfDWqQr8dgHTPXu-bZ76lbySEmofNjsoM
//          JWAdBreak(tag: "https://aj1602.online/z_8tcqQnOOmv7z9a-KOOpYRhxj3cFQCAIlNwEin3o2VbKKZCzgoqLwsJ1sgu4snGOUgrU4flg3NwayprNqRKTuWEOm2hznOg", offset:"pre")
//            JWAdBreak(tag: "https://aj1602.online/zvRz4tZqKDwTADNsSsjEvFiXzR2_u7x4haxiukoJq4Y9Qy8haxE5LG5LFeUken7WOoFhFoJ8wMJYX--qhKxpt2D7SwVGAxXw", offset:"pre")
            JWAdBreak(tag: self.modelVideoDetailData?.vast_ad_xml_url ?? "", offset:"")
            
        ]
        
        config.advertising = adConfig
    }
    
    func addToPlaySingleVideo(){
        
        config = JWConfig(contentURL:self.modelVideoDetailData?.video_preview ?? "")
        
        let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        if autoPlaySwitch != ""{
            if autoPlaySwitch == "true"{
                config.autostart = true
            }else{
                config.autostart = false
            }
        }
    }
    
    func addToPlaySingleVideoWithDifferentResolutin(){

        let jw_MediaID = self.modelVideoDetailData?.jw_media_id ?? ""
        let strBase : String = "https://cdn.jwplayer.com/videos/\(jw_MediaID)"
        
        config.sources = [JWSource (file: strBase+"-VHQTos8y.mp4", label: "180p Streaming"),
                          JWSource (file: strBase+"-JlPu1bCN.mp4", label: "270p Streaming"),
                          JWSource (file: strBase+"-ZhZjlnLM.mp4", label: "406p Streaming", isDefault: true),
                          JWSource (file: strBase+"-rZBMt6n1.mp4", label: "720p Streaming"),
                          JWSource (file: strBase+"-VpBztvbg.mp4 ", label: "1080p Streaming")]
        
        let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        if autoPlaySwitch != ""{
            if autoPlaySwitch == "true"{
                config.autostart = true
            }else{
                config.autostart = false
            }
        }
    }
    
    func addItemsToJWPlaylist(){
        
        let item1 = JWPlaylistItem()
        item1.file = "http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4"
        item1.title = "Video 1"
        
        let item2 = JWPlaylistItem()
        item2.file = "http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4"
        item2.title = "Video 2"
        
        let item3 = JWPlaylistItem()
        item3.file = "http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4"
        item3.title = "Video 3"
        
        let item4 = JWPlaylistItem()
        item4.file = "http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4"
        item4.title = "Video 4"
        
        arrPlaylist.append(item1)
        arrPlaylist.append(item2)
        arrPlaylist.append(item3)
        arrPlaylist.append(item4)
        
        config.playlist = arrPlaylist
    }
    
    @IBAction func insertAd(_ sender: UIButton) {
        jwPlayer.playAd("http://playertest.longtailvideo.com/adtags/preroll_newer.xml")
    }
    
    //MARK:- JWPlayer Delegate Methods
    func onAdError(_ event: (JWAdEvent & JWErrorEvent)!) {
        print(event.description)
    }
    
    func onReady(_ event: (JWEvent & JWReadyEvent)!) {
        self.jwPlayer.view.frame = self.viewVideo.frame
    }
    
    func onFullscreenRequested(_ event: (JWEvent & JWFullscreenEvent)!) {
        self.isFullScreen = !self.isFullScreen
        self.onFullscreenToggled(fullscreen: self.isFullScreen)
    }
    
    
    
    func onLevels(_ event: (JWEvent & JWLevelsEvent)!) {
        print("onLevels")
    }
    func onLevelsChanged(_ event: (JWEvent & JWLevelsChangedEvent)!) {
        print("onLevelsChanged")
    }
    func onControls(_ event: (JWEvent & JWControlsEvent)!) {
        print("onControls")
    }
    func onControlBarVisible(_ event: (JWEvent & JWControlsEvent)!) {
        
        if showControl == false
        {
            DispatchQueue.main.async {
                self.viewTop.isHidden = false
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.viewTop.isHidden = true
            }
        }
        showControl = !showControl
        
        print("onControlBarVisible")
    }
    func onRelatedOpen(_ event: (JWRelatedEvent & JWRelatedOpenEvent)!) {
        print("onRelatedOpen")
    }
    func onRelatedClose(_ event: (JWRelatedEvent & JWRelatedInteractionEvent)!) {
        print("onRelatedClose")
    }
    
    func onPlay(_ event: (JWEvent & JWStateChangeEvent)!) {
       // self.viewTop.isHidden = false
    }
    func onPause(_ event: (JWEvent & JWStateChangeEvent)!) {
       // self.viewTop.isHidden = true
    }
    func onDisplayClick() {
      //  self.viewTop.isHidden = false
    }

    
    
    func onFullscreen(_ event: (JWEvent & JWFullscreenEvent)!) {
        //print("onFullscreen")
    }
    
    func onAdClick(_ event: (JWAdEvent & JWAdDetailEvent)!) {
        GLOBAL.sharedInstance.isAdTapped = true
        jwPlayer.openSafariOnAdClick = true
    }
    
    func onComplete() {
        
        let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        if autoPlaySwitch != ""{
            if autoPlaySwitch == "true"{
                self.setAutoPlaySequence()
            }
        }else{
            self.setAutoPlaySequence()
        }
    }
    
    func setAutoPlaySequence() {
        if isFromPlaylist{
            if self.aryPlaylistVideos.count > 1{
                if self.indexOfPlaylist == self.aryPlaylistVideos.count{
                    self.indexOfPlaylist = 0
                }else{
                    self.indexOfPlaylist = self.indexOfPlaylist + 1
                }
                
                self.strSelectedVideoId = self.aryPlaylistVideos[self.indexOfPlaylist].uuid ?? ""
                self.initialSetup()
            }
        }
        else{ //For recommended videos
            if self.aryRecommendedVideos.count > 0{
                let objRecommended = self.aryRecommendedVideos[0]
                self.strSelectedVideoId = objRecommended.video_uuid ?? ""
                self.initialSetup()
            }
        }
    }
    
    
    
    //    func onTime(_ event: (JWEvent & JWTimeEvent)!) {
    //        //var text: String = String(format: "%.1f", event.position) + " / "
    //        //text += String(format: "%.1f", event.duration)
    //        //playbackTime.text = text
    //    }
    //
    //    func onBuffer(_ event: (JWEvent & JWBufferEvent)!) {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onIdle(_ event: (JWEvent & JWStateChangeEvent)!) {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onPlaylistComplete() {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onAdSkipped(_ event: (JWAdEvent & JWAdDetailEvent)!) {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onAdComplete(_ event: (JWAdEvent & JWAdDetailEvent)!) {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onAdImpression(_ event: (JWAdEvent & JWAdImpressionEvent)!) {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onBeforePlay() {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onBeforeComplete() {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onAdPlay(_ event: (JWAdEvent & JWAdStateChangeEvent)!) {
    //        //playButton?.setTitle("Pause", for: UIControl.State())
    //    }
    //
    //    func onAdPause(_ event: (JWAdEvent & JWAdStateChangeEvent)!) {
    //        //playButton?.setTitle("Play", for: UIControl.State())
    //    }
    //
    
    
    
    
    //    @IBAction func play(_ sender: UIButton) {
    //        if(jwPlayer.state == JWPlayerStatePaused ||
    //            jwPlayer.state == JWPlayerStateIdle) {
    //            jwPlayer.play()
    //            playButton?.setTitle("Pause", for: UIControl.State())
    //        } else {
    //            jwPlayer.pause()
    //            playButton?.setTitle("Play", for: UIControl.State())
    //        }
    //    }
    
    
    
    
    func setupCallbacks(){
        
        let notifications = [
            JWPlayerStateChangedNotification,
            JWMetaDataAvailableNotification,
            JWAdActivityNotification,
            JWErrorNotification,
            JWCaptionsNotification,
            JWVideoQualityNotification,
            JWPlaybackPositionChangedNotification,
            JWFullScreenStateChangedNotification,
            JWAdClickNotification]
        
        let center:  NotificationCenter = .default
        for(_, notification) in notifications.enumerated() {
            center.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name(rawValue: notification), object: nil)
        }
        //        center.addObserver(self, selector: #selector(updatePlaybackTimer(_:)), name: NSNotification.Name(rawValue: JWPlaybackPositionChangedNotification), object: nil)
        //        center.addObserver(self, selector: #selector(playerStateChanged(_:)), name: NSNotification.Name(rawValue: JWPlayerStateChangedNotification), object: nil)
        //        center.addObserver(self, selector: #selector(playerStateChanged(_:)), name: NSNotification.Name(rawValue: JWAdActivityNotification), object: nil)
        
        //     center.addObserver(self, selector: #selector(playerFullScreen(_:)), name: NSNotification.Name(rawValue: JWFullScreenStateChangedNotification), object: nil)
    }
     
    @objc func handleNotification(_ notification: Notification) {
        var userInfo: Dictionary = (notification as NSNotification).userInfo!
        let callback: String = userInfo["event"] as! String
        
        if(callback == "onTime") {return}

        print("*****----- \(callback) -----*****")
        
//        var text: String = callbacksView!.text
//        text = text.appendingFormat("\n%@", callback)
//        callbacksView?.text = text
//
//        let size: CGSize = callbacksView!.sizeThatFits(CGSize(width: callbacksView!.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
//        callbacksView?.contentSize = size as CGSize
//
//        if(callbacksView!.contentSize.height > callbacksView!.frame.size.height) {
//            callbacksView!.setContentOffset(CGPoint(x: 0, y: callbacksView!.contentSize.height-callbacksView!.frame.size.height), animated: true)
//        }
    }
    
    /*
    @objc func updatePlaybackTimer(_ notification: Notification) {
        let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        if(userInfo["event"] as! String == "onTime") {
            var text: String = String(format: "%.1f", userInfo["position"] as! Double) + " / "
            text += String(userInfo["duration"] as! Int)
            
            playbackTime.text = text
        }
    }
     
    @objc func playerStateChanged(_ info: Notification) {
        let userInfo: NSDictionary = (info as NSNotification).userInfo! as NSDictionary
        if( userInfo["event"] as! String == "onPause" ||
            userInfo["event"] as! String == "onReady" ||
            userInfo["event"] as! String == "onAdPause") {
            playButton?.setTitle("Play", for: UIControl.State())
        } else {
            playButton?.setTitle("Pause", for: UIControl.State())
        }
    }
     
    @objc func playerFullScreen(_ info: Notification) {
        self.isFullScreen = !self.isFullScreen
        self.onFullscreenToggled(fullscreen: self.isFullScreen)
    }
    */
}

//MARK: - API
extension VideoDetailVC{
    
    func callVideoDetailAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.uuid : strSelectedVideoId]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_VideoDetailResponse.self,apiName:APIName.VideoDetail, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                self.modelVideoDetailData = response.data
            }
            //self.tblvVideoDetail.reloadData()
            
            self.setupDeviceOrientation()
            self.callGetRecommendedVideoAPI()
            
        }, FailureBlock: { (error) in
            self.hideLoader()
            self.setupDeviceOrientation()
            self.callGetRecommendedVideoAPI()
        })
    }
    
    func callGetRecommendedVideoAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.related_media_id : self.modelVideoDetailData?.jw_media_id ?? "",
                                          KEYS_API.page_offset : String(self.aryRecommendedVideos.count+1),
                                          KEYS_API.page_limit : PAGE_LIMIT_DETAIL,]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.GetRecommendedVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                //self.totalRecords = response.recordsTotal ?? 0
                
                if self.aryRecommendedVideos.count == 0{
                    self.aryRecommendedVideos = [Model_VideoData]()
                }
                
                let responseArray = response.data ?? [Model_VideoData]()
                self.aryRecommendedVideos.append(contentsOf: (responseArray))
                
                if(responseArray.count >= Int(PAGE_LIMIT_DETAIL)!){
                    self.isViewMore_Recommended = true
                }
                else{
                    self.isViewMore_Recommended = false
                }
                
                //self.tblvVideoDetail.reloadData()
                self.callGetVideoCommentsListAPI(sortType: "", strStart: String(self.aryVideoComments.count), strSortParam: Cons_Created_at, isFromViewMore: false)
            }
            
            
        }, FailureBlock: { (error) in
            self.hideLoader()
            //self.tblvVideoDetail.reloadData()
            self.callGetVideoCommentsListAPI(sortType: "", strStart: String(self.aryVideoComments.count), strSortParam: Cons_Created_at, isFromViewMore: false)
        })
    }
    
    func callGetVideoCommentsListAPI(sortType: String,strStart:String,strSortParam:String,isFromViewMore:Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.sort_param : strSortParam,
                                          KEYS_API.sort_type : sortType,
                                          KEYS_API.uuid : self.modelVideoDetailData?.video_uuid ?? "",
                                          KEYS_API.start : strStart,
                                          KEYS_API.length : PAGE_LIMIT_DETAIL,]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_VideoCommentListingResponse.self,apiName:APIName.VideoCommentList, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                //self.totalRecords = response.recordsTotal ?? 0
                
                if self.aryVideoComments.count == 0 || strStart == "0" {
                    self.aryVideoComments = [Model_CommentListingData]()
                }
                
                let responseArray = response.data?.original?.data ?? [Model_CommentListingData]()
                self.aryVideoComments.append(contentsOf: (responseArray))
                
                if(responseArray.count >= Int(PAGE_LIMIT_DETAIL)!){
                    self.isViewMore_Comments = true
                }
                else{
                    self.isViewMore_Comments = false
                }
                
                self.parentView.isHidden = false
                if !isFromViewMore{
                    self.setupJWPlayer()
                }
                self.tblvVideoDetail.reloadData()
                
                if self.isFromPlaylist{
                    self.callGetPlaylistVideoAPI(playlistId: self.strPlaylistVideoId)
                }
            }
            
            
        }, FailureBlock: { (error) in
            self.hideLoader()
            self.parentView.isHidden = false
            if !isFromViewMore{
                self.setupJWPlayer()
            }
            self.tblvVideoDetail.reloadData()
            
            if self.isFromPlaylist{
                self.callGetPlaylistVideoAPI(playlistId: self.strPlaylistVideoId)
            }
        })
    }
    
    func callGetPlaylistVideoAPI(playlistId: String){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.playlistUuid : playlistId ,
                                          KEYS_API.start : String(self.aryPlaylistVideos.count),
                                          KEYS_API.length : PAGE_LIMIT_DETAIL,]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelPlaylistList.self,apiName:APIName.VideoPlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.modelPlaylistInfo = response.data?.playlistInfo
                self.modelPlaylist = response.data?.original
                
                if self.aryPlaylistVideos.count == 0{
                    self.aryPlaylistVideos = [playlistMainData]()
                }
                
                let responseArray = response.data?.original?.data ?? [playlistMainData]()
                self.aryPlaylistVideos.append(contentsOf: (responseArray))
                
                if(responseArray.count >= Int(PAGE_LIMIT_DETAIL)!){
                    self.isViewMore_Playlist = true
                }
                else{
                    self.isViewMore_Playlist = false
                }
                
                self.tblvVideoDetail.reloadData()
            }
            
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
}
