//
//  TermsAndConditionVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 25/04/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class TermsAndConditionVC: ParentVC, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webvTerms: UIWebView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnBackWidthConst: NSLayoutConstraint!
    
    @IBOutlet weak var imgvCheck: UIImageView!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblReadAgree: darkGreyLabelCtrlModel!
    @IBOutlet weak var btnReadAgree: UIButton!
    
    
    var isTermsSelected = Bool()
    var isFromRegister = Bool()
    
    var paramRegister = [String:String]()
    
    //MARK:- Viewcontroller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webvTerms.delegate = self
        webvTerms.scrollView.delegate = self
        
        self.lblTitle.text = "End User License Agreement"
        
        let reqURL =  NSURL(string:  GLOBAL.sharedInstance.UserAgreement)
        let url = NSURLRequest(url: reqURL! as URL)
        webvTerms.loadRequest(url as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        webvTerms.scrollView.showsHorizontalScrollIndicator = false
        
        DispatchQueue.main.async {
            self.showLoader()
        }
        
        if isFromRegister {
            btnBack.isHidden = false
            btnBackWidthConst.constant = 40.0
        }
        else{
            btnBack.isHidden = true
            btnBackWidthConst.constant = 0.0
        }
        
        self.imgvCheck.isHidden    = true
        self.lblReadAgree.isHidden = true
        self.btnReadAgree.isHidden = true
        
        self.checkForTermsSelection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Webview delegate Methods
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        if scrollView == webvTerms.scrollView{
//            if (scrollView.contentOffset.y == 0) {
//                self.imgvCheck.isHidden    = false
//                self.lblReadAgree.isHidden = false
//                self.btnReadAgree.isHidden = false
//            }
//        }
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == webvTerms.scrollView{
            self.imgvCheck.isHidden    = false
            self.lblReadAgree.isHidden = false
            self.btnReadAgree.isHidden = false
        }
    }
    
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
    
    //MARK:- Helper Methods
    func checkForTermsSelection(){
        if isTermsSelected {
            imgvCheck.image = UIImage(named : "Check")
            btnContinue.setTitleColor(UIColor.theme_green, for: .normal)
            btnContinue.isEnabled = true
        }
        else{
            imgvCheck.image = UIImage(named : "Uncheck")
            btnContinue.setTitleColor(UIColor.lightGray, for: .normal)
            btnContinue.isEnabled = false
        }
    }
    
    func goAhead(){
        
        let IS_SKIP : Bool = DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_SKIP)
        
        if IS_SKIP == false {
            let IS_LOGIN : Bool = DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_LOGIN)
            if IS_LOGIN == false{//|| !IS_REMEMBER_ME{
                print("Not login")
                self.redirctToLoginScreen()
                
                //Remove Skip
//                if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
//                    self.redirctToLoginScreen()
//                }else{
//                    self.redirectToHomeScreen()
//                }
            }else if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil{//IS_REMEMBER_ME
                self.redirectToHomeScreen()
            }else{
                self.redirctToLoginScreen()
            }
        }else{
            self.redirctToLoginScreen()
            //self.redirectToHomeScreen() //Remove Skip
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnTermsTap(_ sender: UIButton) {
        isTermsSelected = !isTermsSelected
        self.checkForTermsSelection()
    }
    
    @IBAction func btnContinueTap(_ sender: UIButton) {
        
        if isFromRegister {
            self.callRegisterAPI()
        }
        else{
            DefaultValue.shared.setBoolValue(value: true, key: KEYS_USERDEFAULTS.IS_LICENCE_VERIFIED)
            self.goAhead()
        }
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        POP_VC()
    }
    
    //MARK:- API
    func callRegisterAPI()  {

        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)

//        let queryParams: [String: String] = [KEYS_API.first_name : txtFirstName.txtField.text!,
//                                             KEYS_API.last_name : txtLastName.txtField.text!,
//                                             KEYS_API.email: txtEmail.txtField.text!,
//                                             KEYS_API.username: txtUserName.txtField.text!,
//                                             KEYS_API.date_of_birth: self.txtDOB.txtField.text!,
//                                             KEYS_API.gender: txtGender.txtField.text!,
//                                             KEYS_API.password: txtPassword.text!,
//                                             KEYS_API.confirm_password: txtConfirmPassword.txtField.text!,
//                                             KEYS_API.agreedToTermsAndPrivacyPolicy: strAgreement,
//                                             KEYS_API.subscribe_newsletter: strNewsletter,
//                                             KEYS_API.platform : APIConstant.platform,
//                                             KEYS_API.device_token : GLOBAL.sharedInstance.getDeviceToken(),
//                                             KEYS_API.version : KEYS_API.app_version]

        self.showLoader()

        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelRegistration.self,apiName:APIName.Register, requestType: .post, paramValues: self.paramRegister, headersValues: headerParams, SuccessBlock: { (response) in

            self.hideLoader()

            print("\n-------------------------API Response :-----------------------\n",response)

            let statusCode  = response.meta?.status_code ?? 0

            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                Alert.shared.showAlertWithHandler(title: App_Name, message: (response.meta?.message)!, okButtonTitle: Cons_Ok, handler: { (action) in
                    //Redirect to Login screen
                    self.redirctToLoginScreen()
                })
            }

        }, FailureBlock: { (error) in
            self.hideLoader()
        })

    }
    
}
