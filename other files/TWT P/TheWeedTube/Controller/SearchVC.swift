//
//  SearchVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 27/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class SearchVC: ParentVC, UITextFieldDelegate {

    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    
    
    //MARK: - Properties
    var arySearchs = [String]()
    var is_searching:Bool!
    var searchStr : String = ""

    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        self.prepareViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.closeButtonState()
        txtSearch.becomeFirstResponder()
        if txtSearch.text == ""{
            self.btnClose.alpha = 0.0
        }
    }
    
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func prepareViews(){
        
        self.lblNoData.isHidden = true
        
        is_searching = false
        txtSearch.delegate = self
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search TheWeedTube",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        
        tblSearch.register(UINib.init(nibName: "CellSearch", bundle: nil), forCellReuseIdentifier: "CellSearch_ID")
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.image = UIImage(named: "Nav_back")
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        
        let statusbarHeight = UIApplication.shared.statusBarView?.frame.height ?? 0.0
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            self.tblBottomConstraint.constant = keyboardSize.height - navHeight - statusbarHeight + 10
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        self.tblBottomConstraint.constant = 0.0
    }
    
    func closeButtonState(){
        if (txtSearch.text?.count)! > 0 {
            self.btnClose.isEnabled = true
            self.btnClose.alpha = 1.0
        }else{
            self.btnClose.isEnabled = false
            self.btnClose.alpha = 0.5
        }
    }
    
    //MARK: - Action Methods
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCloseTap(_ sender: UIButton) {
        self.txtSearch.text = ""
        self.closeButtonState()
        self.btnClose.alpha = 0.0
    }
    
    //MARK:- UITextFieldDelegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        let charCount = textField.text?.count ?? 0
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            if charCount == 3 || charCount == 2 {
                self.arySearchs = [String]()
                self.tblSearch.reloadData()
                self.tblSearch.isHidden = true
            }else if charCount == 1{
                self.btnClose.setImage(UIImage(named: ""), for: .normal)
            }else{
                if charCount >= 2{
                    let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                    searchStr = newString
                    self.callSearchAPI(inMainthread: false)
                }
            }
        }else{
            if charCount > 0{
                is_searching = true
                self.btnClose.setImage(UIImage(named: "Nav_close"), for: .normal)
            }else{
                is_searching = false
                self.btnClose.setImage(UIImage(named: ""), for: .normal)
            }
            
            if charCount >= 2{
                let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                searchStr = newString
                self.callSearchAPI(inMainthread: false)
            }
            
            if charCount < 3 {
                //EHGlobal.sharedInstance.hideLoadingIndicator()
            }
        }
        
        self.closeButtonState()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            textField.resignFirstResponder()
            //            self.callSearchAPI()
            self.searchBarSearchButtonClicked(textField.text!)
            return true
        }else{
            return false
        }
        
    }
    
    private func searchBarSearchButtonClicked(_ searchStr: String) {
        print("You have searched for ", searchStr)
        self.view.endEditing(true)
        self.searchStr = searchStr
        //self.callSearchAPI(inMainthread: false)
        
        let objSearchResult = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.SearchResultVC) as! SearchResultVC
        objSearchResult.searchStr = self.searchStr
        self.navigationController?.pushViewController(objSearchResult, animated: true)
    }
    
    //MARK:- API
    func callSearchAPI(inMainthread: Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.search_param : self.searchStr]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Search_Autocomplete_Model.self,apiName:APIName.VideoAutoComplete, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.arySearchs = [String]()
                let responseArray = response.data ?? [String]()
                self.arySearchs.append(contentsOf: responseArray)
                
                if self.arySearchs.count > 0{
                    self.lblNoData.isHidden = true
                }
                else
                {
                    self.lblNoData.isHidden = true
                }
                self.tblSearch.reloadData()
            }
            
            
        }, FailureBlock: { (error) in
            if inMainthread {
                self.hideLoader()
            }
            if self.arySearchs.count > 0{
                self.lblNoData.isHidden = true
            }
            else
            {
                self.lblNoData.isHidden = true
            }
            self.tblSearch.reloadData()
        })
    }
}

//MARK:- UITableViewDataSource and UITableViewDelegate Methods
extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arySearchs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch_ID", for: indexPath) as! CellSearch
        cell.lblSearchedText.text = self.arySearchs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.txtSearch.text = self.arySearchs[indexPath.row]
        
        let objSearchResult = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.SearchResultVC) as! SearchResultVC
        objSearchResult.searchStr = self.arySearchs[indexPath.row]
        self.navigationController?.pushViewController(objSearchResult, animated: true)
    }
    
}
