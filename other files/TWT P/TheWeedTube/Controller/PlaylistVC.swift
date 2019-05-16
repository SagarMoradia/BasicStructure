//
//  PlaylistVC.swift
//  TheWeedTube
//
//  Created by Sandip patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class PlaylistVC: ParentVC,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tblPlaylist: UITableView!
    @IBOutlet weak var lblDropDownSelect: UILabel!
    
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    
    var arrModelPlaylist = [Model_Playlist]()
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        
        //Temp data...
        self.prepareTempData()
        
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        
        self.lblNoData.isHidden = true
        
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationItem.title = Cons_Settings
        tblPlaylist.register(UINib.init(nibName: "CellPlaylist_1", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_1")
        tblPlaylist.register(UINib.init(nibName: "CellPlaylist_2", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_2")
        tblPlaylist.register(UINib.init(nibName: "CellPlaylist_3", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_3")
    }
    
    func prepareTempData() {
        
        //[5]
        var aryPlaylistData = [Model_PlaylistData]()
        
        var modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "1"
        modelPlaylistData.videoThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Windrder2-web_bd5cb0f721881d106522f6b9cc8f5be6.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "2"
        modelPlaylistData.videoThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Solar-web_17f1199fab90a9f453b9ba4167c28e87.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "3"
        modelPlaylistData.videoThumbImageURL = "https://pub-static.haozhaopian.net/assets/projects/pages/a5c58720-14b6-11e9-8f31-654312cfc72b_c1ab6bba-ba97-43b1-894f-222af8a874ce_thumb.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "4"
        modelPlaylistData.videoThumbImageURL = "https://pub-static.haozhaopian.net/assets/projects/pages/a5c58720-14b6-11e9-8f31-654312cfc72b_c1ab6bba-ba97-43b1-894f-222af8a874ce_thumb.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "5"
        modelPlaylistData.videoThumbImageURL = "https://pub-static.haozhaopian.net/assets/projects/pages/a5c58720-14b6-11e9-8f31-654312cfc72b_c1ab6bba-ba97-43b1-894f-222af8a874ce_thumb.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        var playlist = Model_Playlist()
        playlist.playlistName = "Effective Ways To Quit Smoking"
        playlist.playlistDate = "Updated Today"
        playlist.playList = aryPlaylistData
        arrModelPlaylist.append(playlist)
        
        //[3]
        aryPlaylistData = [Model_PlaylistData]()
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "1"
        modelPlaylistData.videoThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Windrder2-web_bd5cb0f721881d106522f6b9cc8f5be6.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "2"
        modelPlaylistData.videoThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Solar-web_17f1199fab90a9f453b9ba4167c28e87.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "3"
        modelPlaylistData.videoThumbImageURL = "https://pub-static.haozhaopian.net/assets/projects/pages/a5c58720-14b6-11e9-8f31-654312cfc72b_c1ab6bba-ba97-43b1-894f-222af8a874ce_thumb.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        playlist = Model_Playlist()
        playlist.playlistName = "Effective Ways To Quit Smoking"
        playlist.playlistDate = "Updated Today"
        playlist.playList = aryPlaylistData
        arrModelPlaylist.append(playlist)
        
        //[2]
        aryPlaylistData = [Model_PlaylistData]()
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "1"
        modelPlaylistData.videoThumbImageURL = "https://pub-static.haozhaopian.net/assets/projects/pages/a5c58720-14b6-11e9-8f31-654312cfc72b_c1ab6bba-ba97-43b1-894f-222af8a874ce_thumb.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        modelPlaylistData = Model_PlaylistData()
        modelPlaylistData.videoID = "2"
        modelPlaylistData.videoThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Solar-web_17f1199fab90a9f453b9ba4167c28e87.jpg"
        aryPlaylistData.append(modelPlaylistData)
        
        playlist = Model_Playlist()
        playlist.playlistName = "Effective Ways To Quit Smoking"
        playlist.playlistDate = "Updated Today"
        playlist.playList = aryPlaylistData
        arrModelPlaylist.append(playlist)
        
        
        //[1]
        for i in 0  ..< 5 {
            aryPlaylistData = [Model_PlaylistData]()
            
            modelPlaylistData = Model_PlaylistData()
            modelPlaylistData.videoID = "\(i+1)"
            modelPlaylistData.videoThumbImageURL = "https://www.bannerbatterien.com/upload/filecache/Banner-Batterien-Windrder2-web_bd5cb0f721881d106522f6b9cc8f5be6.jpg"
            aryPlaylistData.append(modelPlaylistData)
            
            playlist = Model_Playlist()
            playlist.playlistName = "Train Your Brain This New Years"
            playlist.playlistDate = "Updated Today"
            playlist.playList = aryPlaylistData
            arrModelPlaylist.append(playlist)
        }
        
        self.tblPlaylist.reloadData()
    }
    
    //MARK: - Action Methods
    @IBAction func actionDropDownTap(_ sender: UIControl) {
        
    }
}

//MARK: - Tableview Datasource and Delegate Methods
extension PlaylistVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrModelPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let modelPlaylist = self.arrModelPlaylist[indexPath.row]
        var mediaCount = modelPlaylist.playList?.count ?? 0
        mediaCount = mediaCount == 0 ? 1 : mediaCount > 3 ? 3 : mediaCount
        let cell = tblPlaylist.dequeueReusableCell(withIdentifier: "ID_CellPlaylist_\(mediaCount)", for: indexPath) as! CellPlaylist
            cell.objModelPlaylist = modelPlaylist
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.PUSH_STORY_R2(Identifier: "CategorylistVC")
    }
}
