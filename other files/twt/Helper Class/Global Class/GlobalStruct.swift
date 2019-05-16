//
//  GlobalStruct.swift
//  DELRentals
//
//  Created by Sweta Vani on 09/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import UIKit
import Foundation


struct Device {
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568      //SE,5,5C,5S
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667      //6,6S,7,8
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736      //6 plus,6s plus,7 plus,8 plus
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812      //X,XS
    static let IS_IPHONE_XS_MAX    = IS_IPHONE && SCREEN_MAX_LENGTH == 896      //XS Max,XR
}

//struct USERDEFAULT_KEYS {
//    static let user_data : String = "user_data"
//    static let authorization : String = "authorization"
//    static let IS_LOGIN : String = "IS_LOGIN"
//    static let EMAIL : String = "EMAIL"
//    static let PASSWORD : String = "PASSWORD"
//    
//    static let IS_REMEMBER_ME : String = "IS_REMEMBER_ME"
//    static let IS_AGREEMENT_TERMS : String = "IS_AGREEMENT_TERMS"
//    static let IS_NEWSLETTER : String = "IS_NEWSLETTER"
//    static let IS_GENDER_CHANGE : String = "IS_GENDER_CHANGE"
//    static let IS_AGE_VERIFIED : String = "IS_AGE_VERIFIED"
//    
//    //sweta
//    static let GLOBAL_UPDATES_SWITCH_ON : String = "GLOBAL_UPDATES_SWITCH_ON"
//    static let WEEDTUBE_UPDATES_SWITCH_ON : String = "WEEDTUBE_UPDATES_SWITCH_ON"
//    static let NEWSLETTER_SWITCH_ON : String = "NEWSLETTER_SWITCH_ON"
//    static let ACTIVITY_ON_VIDEO_SWITCH_ON : String = "ACTIVITY_ON_VIDEO_SWITCH_ON"
//    static let ACTIVITY_ON_COMMENTS_SWITCH_ON : String = "ACTIVITY_ON_COMMENTS_SWITCH_ON"
//    static let REPLIES_COMMENT_SWITCH_ON : String = "REPLIES_COMMENT_SWITCH_ON"
//    static let ACTIVITY_ON_OTHER_SWITCH_ON : String = "ACTIVITY_ON_OTHER_SWITCH_ON"
//    static let SOMEONE_FOLLOW_SWITCH_ON : String = "SOMEONE_FOLLOW_SWITCH_ON"
//    
//    //Profile
//    static let FACEBOOK : String = "FACEBOOK"
//    static let TWITTER : String = "TWITTER"
//    static let INSTAGRAM : String = "INSTAGRAM"
//    static let SNAPCHAT : String = "SNAPCHAT"
//}

struct FontFamily {
    static let regular   = "InterUI-Regular"
    static let bold      = "InterUI-Bold"
    static let medium    = "InterUI-Medium"
    static let semi_bold = "InterUI-SemiBold"
}

struct STORYBOARD_IDENTIFIER {
    static let LoginVC                 = "LoginVC"
    static let ForgotPasswordVC        = "ForgotPasswordVC"
    static let ForgotPasswordSuccessVC = "ForgotPasswordSuccessVC"
    static let RegisterVC              = "RegisterVC"
    static let ProfileVC               = "ProfileVC"
    static let ProfileMainVC           = "ProfileMainVC"
    static let SettingsVC              = "SettingsVC"
    static let ChangePasswordVC        = "ChangePasswordVC"
    static let EmailNotificationsVC    = "EmailNotificationsVC"
    static let MoreVC                  = "MoreVC"
    static let HomeVC                  = "HomeVC"
    static let NotificationVC          = "NotificationVC"
    static let EditProfileVC           = "EditProfileVC"
    static let CmsVC                   = "CmsVC"
    static let SearchVC                = "SearchVC"
    static let SearchResultVC          = "SearchResultVC"
    static let BlockedChannelsVC         = "BlockedChannelsVC"
}

struct STORYBOARD{
    static let Main = "Main"
    static let Main_R1 = "Main_R1"
}

struct MORE {
    static let Notifications = "Notifications"
    static let Settings = "Settings"
    static let Help = "Help"
    static let Logout = "Log out"
}

struct SOCIALMEDIA {
    static let social_media_name = "social_media_name"
    static let social_media_url = "social_media_url"
}

struct GENDER {
    static let male = "male"
    static let female = "female"
}

class GlobalStruct: NSObject {

    static let sharedInstance = GlobalStruct()
    
   

    
}
