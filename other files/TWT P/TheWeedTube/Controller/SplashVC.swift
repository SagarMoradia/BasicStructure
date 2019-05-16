//
//  SplashVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 04/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class SplashVC: ParentVC {
    
    @IBOutlet var imgSplash:UIImageView!
    
    //MARK: - Viewcontroller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //GLOBAL.sharedInstance.callAPIForCMSPages()
        self.callAPIForCMSPages()
        
        let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        if autoPlaySwitch == ""{
            DefaultValue.shared.setStringValue(value: "true", key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
        }
        
//        perform(#selector(redirectToLogin), with: nil, afterDelay:2.0)
//        perform(#selector(callVersioningAPI), with: nil, afterDelay:2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgSplash.image = appLaunchImage()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Launch screen Methods
    func appLaunchImage() -> UIImage
    {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        
        for imageName in allPngImageNames
        {
            guard imageName.contains("LaunchImage") else { continue }
            
            guard let image = UIImage(named: imageName) else { continue }
            
            
            if (image.scale == UIScreen.main.scale) && (image.size.equalTo(UIScreen.main.bounds.size))
            {
                return image
            }
        }
        
        return UIImage()
    }
    
    @objc func redirectToLogin(){

        if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_LICENCE_VERIFIED){
            
            let termsVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
            termsVC.isFromRegister = false
            self.navigationController?.pushViewController(termsVC, animated: true)
            
        }
        else{
            
            let IS_SKIP : Bool = DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_SKIP)
            
            if IS_SKIP == false {
                let IS_LOGIN : Bool = DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_LOGIN)
                if IS_LOGIN == false{//|| !IS_REMEMBER_ME{
                    print("Not login")
                    self.redirctToLoginScreen()
                    
                     //Remove Skip
//                    if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
//                        self.redirctToLoginScreen()
//                    }else{
//                        self.redirectToHomeScreen()
//                    }
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
        
    }
    
    //MARK: - API
    func callAPIForCMSPages(){
        
        if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_LICENCE_VERIFIED){
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: CMSModel.self,apiName:APIName.CMSLinks, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta){
                
                GLOBAL.sharedInstance.TermsOfService = response.data?.TermsOfService ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.PrivacyPolicy = response.data?.PrivacyPolicy ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.AboutUs = response.data?.AboutUs ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.ContactUs = response.data?.ContactUs ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.Help = response.data?.Help ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.UserAgreement = response.data?.UserAgreement ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.EulaTerms = response.data?.EulaTerms ?? "https://www.theweedtube.com"
                
                self.callAPI()
            }
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func callAPI() {
        perform(#selector(callVersioningAPI), with: nil, afterDelay:2.0)
    }
    
    @objc func callVersioningAPI(){
        
        if (SMNetworkManager.shared.isReachable!) {
            
            let currentVesrion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            
            let parameters = [KEYS_API.curr_version:currentVesrion ?? "1.0",KEYS_API.device_type:APIConstant.platform] as [String:Any]
            
            API.sharedInstance.apiRequestWithModalClass(modelClass: VersionModel.self,apiName:APIName.VersionCheck, requestType: .post, paramValues: parameters, headersValues: nil, SuccessBlock: { (response) in
                
                print("\n-------------------------API Response :-----------------------\n",response)
                if response.data?.force_update?.lowercased() == "yes"{
                    self.showForceUpdateAlert(message:Const_Update_Available) //response.meta.message ??
                }else{
                    self.redirectToLogin()
                }
                
            }, FailureBlock: { (error) in
                self.redirectToLogin()
            })
        }else{
            self.redirectToLogin()
        }
    }
    
    func showForceUpdateAlert(message:String){
        
        Alert.shared.showAlertWithHandler(title:App_Name , message:message, okButtonTitle:Cons_Update_Title) { (action) in
            UIApplication.shared.open(URL.init(string: Cons_App_ITunes_URL)!, options: [:], completionHandler: { (success) in
                print("Open update URL : \(success)")
                self.showForceUpdateAlert(message:message)
            })
        }
    }
}
