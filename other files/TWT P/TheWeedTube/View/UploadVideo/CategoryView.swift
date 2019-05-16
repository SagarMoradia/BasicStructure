//
//  CategoryView.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 27/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

typealias CompletionHandlerBlock = (( _ index:Int, _ strTitle:String, _ propertyId:Int)->())?
typealias CompletionHandlerBlockString = (( _ index:Int, _ strTitle:String, _ propertyId:String)->())?
typealias CompletionHandlerBlockForCategory = (( _ strIDs:String, _ strNames:String)->())?

struct CategoryScreen_TYPE{
    static let UploadCategory = "UploadCategory"
    static let ReportCategory = "ReportCategory"
    static let AddToPlaylist = "AddToPlaylist"
    static let LocalList = "LocalList"
}

class CategoryView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Outlets Methods
    @IBOutlet weak var tblViewCategory: UITableView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var ConstrainHeightValue: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    var strCategoryScreenTYPE = CategoryScreen_TYPE.UploadCategory
    
    //MARK: - Properties Methods
    //Callback
    var handler: CompletionHandlerBlock!
    var handlerString: CompletionHandlerBlockString!
    var handlerCategory: CompletionHandlerBlockForCategory!
    
    //For pop up
    var maxHeight : CGFloat = UIScreen.main.bounds.height/2
    var aryModelCategorylist = [categoryData]()
    var aryModelReportCategorylist = [ReportCategoryData]()
    var aryModelPlaylistData = [PlaylistData]()
    var aryLocalList = [String]()
    var arrCategories = NSMutableArray()
    var isFromEdit = Bool()
    
    //MARK: - View Methods
    override func awakeFromNib() {
        tblViewCategory.register(UINib.init(nibName: "CellPopUp", bundle: nil), forCellReuseIdentifier: "CellPopUp")
        tblViewCategory.tableFooterView = UIView()
    }
    
    func setupData(){
        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.UploadCategory{
            
            self.viewTop.isHidden = false
            self.height.constant = 49.0
            self.btnDone.isHidden = false
            self.btnCancel.isHidden = false
            self.lblName.text = Cons_Category
            
            if GLOBAL.sharedInstance.arrCategory.count > 0{
                
            }else{
                //callGetCategoryAPI(isInMainThread: false)
                tblViewCategory.reloadData()
            }
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.AddToPlaylist{
            self.viewTop.isHidden = false
            self.height.constant = 49.0
            self.btnDone.isHidden = true
            self.btnCancel.isHidden = true
            self.lblName.text = Cons_Playlist
            tblViewCategory.reloadData()
        }
        else{
            self.viewTop.isHidden = true
            self.height.constant = 0.0
            tblViewCategory.reloadData()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.calculatePopUpHeight()
    }
    
    func calculatePopUpHeight(){
        //Dynamic height of suite pop up
        var tableHeight = CGFloat()
        
        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.ReportCategory{
            if aryModelReportCategorylist.count > 0{
                tableHeight = (CGFloat(aryModelReportCategorylist.count)*45.0) as CGFloat
            }else{
                tableHeight = maxHeight
            }
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.AddToPlaylist{
            if aryModelPlaylistData.count > 0{
                tableHeight = (CGFloat(aryModelPlaylistData.count)*45.0) as CGFloat
            }else{
                tableHeight = maxHeight
            }
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.LocalList{
            if aryLocalList.count > 0{
                tableHeight = (CGFloat(aryLocalList.count)*45.0) as CGFloat
            }else{
                tableHeight = maxHeight
            }
        }
        else{
            if arrCategories.count > 0{
                tableHeight = (CGFloat(arrCategories.count)*45.0) as CGFloat
            }else{
                tableHeight = maxHeight
            }
//            if aryModelCategorylist.count > 0{
//                tableHeight = (CGFloat(aryModelCategorylist.count)*45.0) as CGFloat
//            }else{
//                tableHeight = maxHeight
//            }
        }
        
        var tableFrame: CGRect = self.tblViewCategory.frame
        tableFrame.size.height = tableHeight
        self.tblViewCategory.frame = tableFrame
        self.tblViewCategory.reloadData()
        self.tblViewCategory.setNeedsDisplay()
        
        var suiteHeight = CGFloat()
        if tableHeight > maxHeight{
            suiteHeight = maxHeight
        }else{
            suiteHeight = tableHeight
        }
        
        var mainView: CGRect = self.viewParent.frame
        mainView.size.height = suiteHeight
        //mainView.origin.y = self.viewMain.frame.height - mainView.size.height
        self.viewParent.frame = mainView
        
        ConstrainHeightValue.constant = suiteHeight //self.viewMain.frame.height - mainView.size.height
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
    }
    
    
    //MARK:- Button Event Methods
    @IBAction func actionHide(_ sender:UIControl){
        //SMP:Change
        //self.viewMain.backgroundColor = .clear
        self.removeFromSuperviewWithAnimationBottom(animation: {
            
        }) {//Completion
            
            if self.strCategoryScreenTYPE == CategoryScreen_TYPE.UploadCategory{
                
                var strIDs = String()
                var strNames = String()
                for catDict in self.arrCategories{
                    let selected = (catDict as AnyObject).value(forKey: "isSelected") as! Bool
                    let cID = (catDict as AnyObject).value(forKey: "id") as! Int
                    let cName = (catDict as AnyObject).value(forKey: "name") as! String
                    if selected{
                        if strIDs == ""{
                            strIDs = String(cID)+","
                            strNames = cName+", "
                        }else{
                            strIDs = strIDs+String(cID)+","
                            strNames = strNames+cName+", "
                        }
                    }
                }
                strIDs = String(strIDs.dropLast())
                strNames = String(strNames.dropLast())
                strNames = String(strNames.dropLast())
                self.handlerCategory!(strIDs,strNames)
            }
        }
    }
    
    @IBAction func btnCancelTap(_ sender: UIButton) {
        self.removeFromSuperviewWithAnimationBottom(animation: {
            
        }) {//Completion
//            self.arrCategories = NSMutableArray()
//            self.callGetCategoryAPI(isInMainThread: false)
        }
    }
    
    
    //MARK:- Tableview datasource delegate  Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.ReportCategory{
            return self.aryModelReportCategorylist.count
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.AddToPlaylist{
            return self.aryModelPlaylistData.count
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.LocalList{
            return self.aryLocalList.count
        }
        return self.arrCategories.count//self.aryModelCategorylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellPopUp", for: indexPath) as! CellPopUp
        cell.textLabel?.backgroundColor = UIColor.clear
        
        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.ReportCategory{
            let modelReportCategoryData = self.aryModelReportCategorylist[indexPath.row]
            cell.lblName.text = modelReportCategoryData.title ?? ""
            cell.imgvSelect.isHidden = true
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.AddToPlaylist{
            let modelPlaylistData = self.aryModelPlaylistData[indexPath.row]
            cell.lblName.text = modelPlaylistData.name ?? ""
            cell.imgvSelect.isHidden = true
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.LocalList{
            cell.lblName.text = self.aryLocalList[indexPath.row]
            cell.imgvSelect.isHidden = true
        }
        else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.UploadCategory{
            let modelCategoryData = self.arrCategories[indexPath.row]//self.aryModelCategorylist[indexPath.row]
            cell.lblName.text = (modelCategoryData as AnyObject).value(forKey: "name") as? String //modelCategoryData.name ?? ""
            let isSelected = (modelCategoryData as AnyObject).value(forKey: "isSelected") as! Bool
            if isSelected{
                cell.imgvSelect.isHidden = false
            }else{
                cell.imgvSelect.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //SMP:Change
        //self.viewMain.backgroundColor = .clear
        
        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.UploadCategory{
            
            let objCategory = self.arrCategories[indexPath.row]
            let cID = (objCategory as AnyObject).value(forKey: "id") as! Int
            let cUuid = (objCategory as AnyObject).value(forKey: "uuid") as! String
            let cName = (objCategory as AnyObject).value(forKey: "name") as! String
            
            var isSelected = (objCategory as AnyObject).value(forKey: "isSelected") as! Bool
            isSelected = !isSelected
            
            let dict = NSMutableDictionary()
            dict.setValue(cID, forKey: "id")
            dict.setValue(cUuid, forKey: "uuid")
            dict.setValue(cName, forKey: "name")
            dict.setValue(isSelected, forKey: "isSelected")
            
            self.arrCategories.removeObject(at: indexPath.row)
            self.arrCategories.insert(dict, at: indexPath.row)
            
            self.tblViewCategory.reloadData()
            
        }else{
            self.removeFromSuperviewWithAnimationBottom(animation: {
            }) {//Completion
                
                if self.strCategoryScreenTYPE == CategoryScreen_TYPE.ReportCategory{
                    let modelReportCategoryData = self.aryModelReportCategorylist[indexPath.row]
                    let categoryTitle = modelReportCategoryData.title ?? ""
                    let categoryUUID = modelReportCategoryData.uuid ?? ""
                    self.handlerString!(indexPath.row,categoryTitle,categoryUUID)
                }
                else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.AddToPlaylist{
                    let modelPlaylistData = self.aryModelPlaylistData[indexPath.row]
                    let categoryTitle = modelPlaylistData.name ?? ""
                    let categoryUUID = modelPlaylistData.uuid ?? ""
                    self.handlerString!(indexPath.row,categoryTitle,categoryUUID)
                }
                else if self.strCategoryScreenTYPE == CategoryScreen_TYPE.LocalList{
                    let categoryTitle = self.aryLocalList[indexPath.row]
                    self.handlerString!(indexPath.row,categoryTitle,"")
                }
//                else{
//                    let modelCategoryData = self.aryModelCategorylist[indexPath.row]
//                    let categoryName = modelCategoryData.name ?? ""
//                    let categoryId = modelCategoryData.id
//                    self.handler!(indexPath.row,categoryName,categoryId!)
//                }
                
                self.removeFromSuperview()
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.UploadCategory{
//            return 30.0
//        }else{
//            return 0.0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if self.strCategoryScreenTYPE == CategoryScreen_TYPE.UploadCategory{
//            let headerView = Bundle.loadView(fromNib: "HeaderHome", withType: HeaderHome.self)
//            headerView.lblHeaderTitle.text = "Select Category"
//            headerView.lblHeaderTitle.font = fontType.InterUI_Bold_14
//            headerView.lblHeaderTitle.textAlignment = .center
//            headerView.lblHeaderTitle.backgroundColor = UIColor.white
//            return headerView
//
//        }else{
//            return UIView()
//        }
//    }
    
    //MARK:- API Methods
    func callGetCategoryAPI(isInMainThread:Bool)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_CategoryData.self,apiName:APIName.GetCategories, requestType: .get, paramValues: nil, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                    if response.data != nil{
                        self.aryModelCategorylist = [categoryData]()
                        self.aryModelCategorylist = response.data ?? [categoryData]()
                        print("\n----------------Category Data-----------------\n",self.aryModelCategorylist)
                        
                        if self.aryModelCategorylist.count > 0{
                            self.tblViewCategory.isHidden = false
                            self.lblNoData.isHidden = true
                            
                            self.updateArrFromData()
                            
                        }else{
                            self.tblViewCategory.isHidden = true
                            self.lblNoData.isHidden = false
                        }
                        
                        self.calculatePopUpHeight()
                        self.tblViewCategory.reloadData()
                    }else{
                        self.tblViewCategory.isHidden = true
                        self.lblNoData.isHidden = false
                    }
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func updateArrFromData() {
        
        for cat in self.aryModelCategorylist{
            let cID = cat.id ?? 0
            let cUuid = cat.uuid ?? ""
            let cName = cat.name ?? ""
            let isSelected = false
            
            let dict = NSMutableDictionary()
            dict.setValue(cID, forKey: "id")
            dict.setValue(cUuid, forKey: "uuid")
            dict.setValue(cName, forKey: "name")
            dict.setValue(isSelected, forKey: "isSelected")
            
            self.arrCategories.add(dict)
        }
        
        GLOBAL.sharedInstance.arrCategory = self.arrCategories
    }
    
}
