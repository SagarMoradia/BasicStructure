//
//  CmsVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 19/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CmsVC: ParentVC,UIWebViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var webview : UIWebView!
    @IBOutlet weak var lblNavTitle : UILabel!
    @IBOutlet weak var btnAccept: ButtonControlModel!
    @IBOutlet weak var btnHeightConst: NSLayoutConstraint!
    
    var navigationBarIntialValue = false
    
    var isFromAge = false

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        
        let reqURL =  NSURL(string:  webURL)
        let url = NSURLRequest(url: reqURL! as URL)
        webview.loadRequest(url as URLRequest)
        
        lblNavTitle.text = navigationTitle
        
        navigationBarIntialValue = self.navigationController?.navigationBar.isHidden ?? true
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.theme_gray_New
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.showLoader()
        }
        
        if isFromAge{
            btnAccept.isHidden = false
            btnHeightConst.constant = 40.0
        }else{
            btnAccept.isHidden = true
            btnHeightConst.constant = 0.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = navigationBarIntialValue
    }

    //MARK: - Webview delegate Methods
    func webViewDidStartLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.showLoader()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.hideLoader()
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    
    //MARK: - Action Methods
    @IBAction func btnAcceptTap(_ sender: UIButton) {
        DefaultValue.shared.setBoolValue(value: true, key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED)
        self.POP_VC()
    }
}
