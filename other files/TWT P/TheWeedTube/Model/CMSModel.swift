//
//  LoginModel.swift
//  DELRentals
//
//  Created by Sweta Vani on 08/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation

struct CMSModel : Decodable {
    let meta: Model_Meta?
    let data: cmsData?
    let errors : Model_Errors?
}

struct cmsData :Decodable,Encodable{
    let TermsOfService : String?
    let PrivacyPolicy : String?
    let AboutUs : String
    let ContactUs : String?
    let Help : String?
    let UserAgreement : String?
    let EulaTerms : String?
}

/*
 {
 "meta": {
     "status": true,
     "message": "Success",
     "message_code": "SUCCESS",
     "status_code": 200
 },
 "data": {
     "TermsOfService": "https://theweedtube.demo.brainvire.com/cms-pages/terms-of-service",
     "PrivacyPolicy": "https://theweedtube.demo.brainvire.com/cms-pages/privacy-policy",
     "AboutUs": "https://theweedtube.demo.brainvire.com/cms-pages/about",
     "ContactUs": "https://theweedtube.demo.brainvire.com/cms-pages/contact-us",
     "Help": "https://theweedtube.demo.brainvire.com/cms-pages/faq-and-rules",
     "UserAgreement": "https://theweedtube.demo.brainvire.com/cms-pages/user-licence-agreement",
     "EulaTerms": "https://theweedtube.demo.brainvire.com/cms-pages/eula-terms"
 }
 }*/
