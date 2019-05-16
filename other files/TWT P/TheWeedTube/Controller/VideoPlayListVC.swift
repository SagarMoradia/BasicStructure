//
//  VedioPlayListVC.swift
//  TheWeedTube
//
//  Created by Umesh Sharma on 08/04/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class VideoPlayListVC: ParentVC,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblplayListTitle: UILabel!
    @IBOutlet weak var tblvideoplaylist: UITableView!
    @IBOutlet weak var lblTotalVideos: UILabel!
    @IBOutlet weak var viewPlayBtn: UIView!
    
    var isFromPlaylist = Bool()
    var modelVideoDetailData : Model_VideoDetailData? = nil
    var modelPlaylistInfo : PlaylistInfo? = nil
    var modelPlaylist : playlistOriginal? = nil
    var isViewMore_Playlist = true
    var isViewMore_Recommended = true
    var strPlaylistVideoId = ""
    var strSelectedVideoId = ""
    var indexOfPlaylist: Int = 0
    var currentPageOffset: Int = 0
    var strSelectedVideoTitle = ""
    
    //For expand/collapse
    var selectedIndx = -1
    var cellTapped = false
    var selectedIndxCategory = -1
    var cellCategoryTapped = false
    var expandHeight = CGFloat()
    
    var isViewMore_Comments = true
    var isFromViewReplies = Bool()
    
//    var aryRecommendedVideos = [Model_VideoData]()
//    var aryVideoComments = [Model_CommentListingData]()
      var aryPlaylistVideos = [playlistMainData]()
      var arrPlaylist = [playlistDataAry]()
    
    var totalRecords: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(strSelectedVideoId)
        self.tblvideoplaylist.register(UINib(nibName: "VideoListCell", bundle: nil), forCellReuseIdentifier: "VideoListCell")
        callGetPlaylistVideoAPI(playlistId: strPlaylistVideoId)
        
        setupPagination()
    }
    
    override func viewDidLayoutSubviews() {
        prepareview()
    }
    
     //MARK:- Call Api method
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
//                let totalVideos = response.data?.playlistInfo?.total_videos
                let totalvideos = response.data?.original?.recordsTotal ?? 0
                if totalvideos == 1{
                    self.lblTotalVideos.text = "\(totalvideos) Video"
                }else{
                    self.lblTotalVideos.text = "\(totalvideos) Videos"
                }
                self.lblplayListTitle.text = self.strSelectedVideoTitle.stringByDecodingHTMLEntities
                self.tblvideoplaylist.reloadData()
            }
            
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
     //MARK:- custom method
    fileprivate func setupPagination() {
        // Add infinite scroll handler
        tblvideoplaylist.addInfiniteScroll { [weak self] (tableView) -> Void in
            guard let tempSelf = self else{ return }
            tempSelf.callGetPlaylistVideoAPI(playlistId: self!.strPlaylistVideoId)
        }
        tblvideoplaylist.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.totalRecords > self.arrPlaylist.count
        }
    }
    
    func prepareview(){
        viewPlayBtn.layer.cornerRadius = viewPlayBtn.frame.height/2
    }
    
    //MARK:- UITableViewDelegate & UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return aryPlaylistVideos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tblvideoplaylist.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        cell.objModelPlaylistdata = aryPlaylistVideos[indexPath.row]
        cell.strSelectedVideoId = self.aryPlaylistVideos[indexPath.row].uuid!
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromPlaylist{
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        vcDetail.strSelectedVideoId = aryPlaylistVideos[indexPath.row].uuid ?? ""
        vcDetail.strPlaylistVideoId = strPlaylistVideoId
        vcDetail.isFromPlaylist = true
        vcDetail.indexOfPlaylist = indexPath.row
        //            self.navigationController?.present(vcDetail, animated: true, completion: nil)
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }
    
    //MARK:- btnAction method
    @IBAction func btnPlaytapped(_ sender: Any) {
        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        
        if strSelectedVideoId == ""{
            strSelectedVideoId = aryPlaylistVideos[0].uuid ?? ""
        }
        vcDetail.strSelectedVideoId = strSelectedVideoId
        vcDetail.strPlaylistVideoId = strPlaylistVideoId
        vcDetail.isFromPlaylist = true
        //            self.navigationController?.present(vcDetail, animated: true, completion: nil)
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }

}
