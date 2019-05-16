//
//  CategorylistVC.swift
//  TheWeedTube
//
//  Created by Sandip patel on 18/02/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class CategorylistVC: ParentVC,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewAdTop: UIView!
    @IBOutlet weak var viewAdBottom: UIView!
    
    @IBOutlet weak var tblCategorylist: UITableView!
    @IBOutlet weak var imageViewTopAds: UIImageView!
    @IBOutlet weak var imageViewBottomAds: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var aryModelCategorylist = [categoryData]()
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationItem.title = Cons_Settings
        tblCategorylist.register(UINib.init(nibName: "CellCategory", bundle: nil), forCellReuseIdentifier: "ID_CellCategory")
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tblCategorylist.tableHeaderView = UIView(frame: frame)
        self.tblCategorylist.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.lblNoData.text = Cons_Text_NoData
        self.callCategoryListAPI()
    }
    
    //MARK: - Action Methods
    @IBAction func actionSearchIconTap(_ sender: UIControl) {
        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
        let objSearch = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.SearchVC) as! SearchVC
        self.navigationController?.pushViewController(objSearch, animated: false)
    }
}

//MARK: -
extension CategorylistVC{
    //MARK: - Tableview Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryModelCategorylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let modelCategoryData = self.aryModelCategorylist[indexPath.row]
        
        let cell = tblCategorylist.dequeueReusableCell(withIdentifier: "ID_CellCategory", for: indexPath) as! CellCategory
        
        cell.lblCategoryName.text = modelCategoryData.name?.HSDecode ?? ""
        cell.lblVideoCount.text = "\(modelCategoryData.total_videos ?? 0) Videos"
        let badgeCount = modelCategoryData.total_trends ?? 0
        if badgeCount == 0{
            cell.lblBadgeCount.isHidden = true
            cell.lblBadgeCount.text = ""
        }else{
            cell.lblBadgeCount.isHidden = false
            cell.lblBadgeCount.text = "\(badgeCount)"
        }
        
        self.loadImageWith(imgView: cell.imageViewCategory, url: (modelCategoryData.logo_path ?? ""), placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objVideoCategoryListVC = MAKE_STORY_OBJ_R2(Identifier: "VideoCategoryListVC") as! VideoCategoryListVC
        let catID = aryModelCategorylist[indexPath.row].uuid ?? ""
        objVideoCategoryListVC.categoryID = catID
        objVideoCategoryListVC.lblNavigationTitle?.text = aryModelCategorylist[indexPath.row].name
        objVideoCategoryListVC.isFromCategory = true
        self.loadImageWith(imgView: objVideoCategoryListVC.imgNavigationLeft, url: aryModelCategorylist[indexPath.row].logo_path ?? "", placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
        PUSH_STORY_OBJ(obj: objVideoCategoryListVC)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = Bundle.loadView(fromNib: "HeaderAds", withType: HeaderAds.self)
//        self.loadMopubAdForCategoryList(inView: headerView.viewAd)
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 76.0
//    }
    
    //MARK: - API Methods
    func callCategoryListAPI(){
        
//        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
//
//        let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
//                                             KEYS_API.version : KEYS_API.app_version]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_CategoryData.self,apiName:APIName.GetCategories, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if response.data != nil{
                    self.aryModelCategorylist = [categoryData]()
                    self.aryModelCategorylist = response.data!
                    print("\n----------------Category Data-----------------\n",self.aryModelCategorylist)
                    
                    if self.aryModelCategorylist.count > 0{
                        self.tblCategorylist.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblCategorylist.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                    
                    self.tblCategorylist.reloadData()
                }
            }
            
            self.hideLoader()
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
}
