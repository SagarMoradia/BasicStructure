//
//  OwnerSuitesModel.swift
//  DELRentals
//
//  Created by Sweta Vani on 14/11/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation

struct ThemesModel : Decodable {
    let data: [Themes]?
}

struct Themes : Decodable{
    let themeID : String?
    let themeName : String?
    let themeProperties : themeProperties?
}

struct themeProperties : Decodable{
    let buttonControl : buttonControl?  //Main buttons like "LOGIN", "REGISTER" (All green buttons)
    let FollowButtonCtrl : FollowButtonCtrl?  //User > Following > Unsubscribe button
    let darkGreyButtonCtrl : darkGreyButtonCtrl?  //Dark gray btn color (About in profile)
    let greenButtonCtrl : greenButtonCtrl?  //green btn color (Forgot Password, Skip bttons)
    let viewControl : viewControl?  //Main view (white view)
    let underlineViewCtrl : underlineViewCtrl?  //Selected tab line view (green view)
    let greenUnderlineViewCtrl : greenUnderlineViewCtrl?  //Selected tab line view (profile screen)
    let uploadingLightGreenViewCtrl : uploadingLightGreenViewCtrl?  //Uploading stripe view (light green view)
    let uploadLightGreenViewCtrl : uploadLightGreenViewCtrl?  //Uploading background view (light green view)
    let uploadDarkGreyViewCtrl : uploadDarkGreyViewCtrl?  //Upload your custom thumb background view (dark gray view)
    let errorRedViewCtrl : errorRedViewCtrl?  //Error top view
    let blackLabelCtrl : blackLabelCtrl?  //Default lable black color
    let darkGreyLabelCtrl : darkGreyLabelCtrl?  //Dark gray text color (About in profile)
    let lightGreyLabelCtrl : lightGreyLabelCtrl?
    let whiteLabelCtrl : whiteLabelCtrl?  //Default lable white color
    let greenLabelCtrl : greenLabelCtrl?  //Selected lable green color for tab selection
    let yellowLabelCtrl : yellowLabelCtrl? //More > Notification count lable
    let textFieldCtrl : textFieldCtrl? //Default all textfields
    let textViewCtrl : textViewCtrl? //Default all textview
    let seekBar : seekBar?
    let topNavigation : topNavigation?
    let bottomNavigation : bottomNavigation?
    let sideNavigation : sideNavigation?
}

struct buttonControl : Decodable{
    let buttonBackgroundColor : rgba?
    let buttonForegroundColor : rgba?
}
struct FollowButtonCtrl : Decodable{
    let buttonBackgroundColor : rgba?
    let buttonForegroundColor : rgba?
}
struct darkGreyButtonCtrl : Decodable{
    let buttonBackgroundColor : rgba?
    let buttonForegroundColor : rgba?
}
struct greenButtonCtrl : Decodable{
    let buttonBackgroundColor : rgba?
    let buttonForegroundColor : rgba?
}

struct viewControl : Decodable{
    let viewBackgroundColor : rgba?
}
struct underlineViewCtrl : Decodable{
    let viewBackgroundColor : rgba?
}
struct greenUnderlineViewCtrl : Decodable{
    let viewBackgroundColor : rgba?
}
struct uploadingLightGreenViewCtrl : Decodable{
    let viewBackgroundColor : rgba?
}
struct uploadLightGreenViewCtrl : Decodable{
    let viewBackgroundColor : rgba?
}
struct uploadDarkGreyViewCtrl : Decodable{
    let viewBackgroundColor : rgba?
}
struct errorRedViewCtrl : Decodable{
    let viewBackgroundColor : rgba?
}

struct blackLabelCtrl : Decodable{
    let labelBackgroundColor : rgba?
    let labelForegroundColor : rgba?
}
struct darkGreyLabelCtrl : Decodable{
    let labelBackgroundColor : rgba?
    let labelForegroundColor : rgba?
}
struct lightGreyLabelCtrl : Decodable{
    let labelBackgroundColor : rgba?
    let labelForegroundColor : rgba?
}
struct whiteLabelCtrl : Decodable{
    let labelBackgroundColor : rgba?
    let labelForegroundColor : rgba?
}
struct greenLabelCtrl : Decodable{
    let labelBackgroundColor : rgba?
    let labelForegroundColor : rgba?
}
struct yellowLabelCtrl : Decodable{
    let labelBackgroundColor : rgba?
    let labelForegroundColor : rgba?
}

struct textFieldCtrl : Decodable{
    let textBackgroundColor : rgba?
    let textBorderColor : rgba?
    let textForegroundColor : rgba?
}

struct textViewCtrl : Decodable{
    let textBackgroundColor : rgba?
    let textBorderColor : rgba?
    let textForegroundColor : rgba?
}

struct seekBar : Decodable{
    let playingSeekbarColor : rgba?
    let defaultSeekbarColor : rgba?
}

struct topNavigation : Decodable{
    let forgroundColor : rgba?
    let backgroundColor : rgba?
}

struct bottomNavigation : Decodable{
    let forgroundColor : rgba?
    let backgroundColor : rgba?
}

struct sideNavigation : Decodable{
    let forgroundColor : rgba?
    let backgroundColor : rgba?
}

struct rgba : Decodable{
    let r : String?
    let g : String?
    let b : String?
    let a : String?
}


