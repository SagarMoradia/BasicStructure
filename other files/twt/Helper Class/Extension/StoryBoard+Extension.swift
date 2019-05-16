//
//  StoryBoard.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK:- Prepare Storyboard instances
    var MAIN_STORYBOARD_MAIN : UIStoryboard{
        return UIStoryboard.init(name:"Main", bundle: nil)
    }
    var MAIN_STORYBOARD_R1 : UIStoryboard{
        return UIStoryboard.init(name: ("Main_R1"), bundle: nil)
    }
    var MAIN_STORYBOARD_R2 : UIStoryboard{
        return UIStoryboard.init(name: ("Main_R2"), bundle: nil)
    }
    var MAIN_STORYBOARD_R3 : UIStoryboard{
        return UIStoryboard.init(name: ("Main_R3"), bundle: nil)
    }
    var MAIN_STORYBOARD_TABBAR : UIStoryboard{
        return UIStoryboard.init(name: ("Tabbar"), bundle: nil)
    }
    
    var MAIN_STORYBOARD_SIDE_DRAWER : UIStoryboard{
        return UIStoryboard.init(name: ("SideDrawer"), bundle: nil)
    }
    
    func getStoryboardReferenceWithName(_ name:StoryboardName) -> UIStoryboard{
        return UIStoryboard.init(name: (name.rawValue), bundle: nil)
    }
    
    func MAKE_STORY_OBJ(storyboardName:StoryboardName,Identifier:String) -> UIViewController{
        let storyboard = getStoryboardReferenceWithName(storyboardName)
        return storyboard.instantiateViewController(withIdentifier: Identifier)
    }
    
    func MAKE_CLASS_OBJ(Class:AnyClass) -> UIViewController {
        return UINib(nibName: NSStringFromClass(Class), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIViewController
    }
    
    //MARK:- Make class object from Storyboard
    func MAKE_STORY_OBJ_MAIN(Identifier:String) -> UIViewController {
        return MAIN_STORYBOARD_MAIN.instantiateViewController(withIdentifier: Identifier)
    }
    func MAKE_STORY_OBJ_TABBAR(Identifier:String) -> UIViewController {
        return MAIN_STORYBOARD_TABBAR.instantiateViewController(withIdentifier: Identifier)
    }
    func MAKE_STORY_OBJ_R1(Identifier:String) -> UIViewController {
        return MAIN_STORYBOARD_R1.instantiateViewController(withIdentifier: Identifier)
    }
    func MAKE_STORY_OBJ_R2(Identifier:String) -> UIViewController {
        return MAIN_STORYBOARD_R2.instantiateViewController(withIdentifier: Identifier)
    }
    func MAKE_STORY_OBJ_R3(Identifier:String) -> UIViewController {
        return MAIN_STORYBOARD_R3.instantiateViewController(withIdentifier: Identifier)
    }
    
    func MAKE_STORY_OBJ_SIDE_DRAWER(Identifier:String) -> UIViewController {
        return MAIN_STORYBOARD_SIDE_DRAWER.instantiateViewController(withIdentifier: Identifier)
    }
    
    
    //MARK:- Push Storyboard class
    func PUSH_STORY_MAIN(Identifier:String){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(MAKE_STORY_OBJ_MAIN(Identifier: Identifier), animated: true)
    }
    func PUSH_STORY_TABBAR(Identifier:String){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(MAKE_STORY_OBJ_TABBAR(Identifier: Identifier), animated: true)
    }
    func PUSH_STORY_R1(Identifier:String){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(MAKE_STORY_OBJ_R1(Identifier: Identifier), animated: true)
    }
    
    func PUSH_STORY_R2(Identifier:String){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(MAKE_STORY_OBJ_R2(Identifier: Identifier), animated: true)
    }
    func PUSH_STORY_R3(Identifier:String){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(MAKE_STORY_OBJ_R3(Identifier: Identifier), animated: true)
    }
    
    func PUSH_STORY_SIDE_DRAWER(Identifier:String){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(MAKE_STORY_OBJ_SIDE_DRAWER(Identifier: Identifier), animated: true)
    }
    
    
    //MARK:- Push created class object
    func PUSH_STORY_OBJ(obj:UIViewController){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK:- Perform Segue
    func PERFORM_SEGUE(Identifier:String){
        self.performSegue(withIdentifier: Identifier, sender: nil)
    }
    
    //MARK:- POP class object
    func POP_VC(){
        removeToastView()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func POP_TO_VC<T:UIViewController>(controllerClass:T.Type?) -> Bool {
        for vc in (self.navigationController?.viewControllers) ?? []{
            if vc.isKind(of:controllerClass!) {
                self.navigationController?.popToViewController(vc, animated: true)
                
                removeToastView()
                return true
            }
        }
        return false
    }
    
    
    
    func POP_TO_ROOT() {
        removeToastView()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func removeToastView() {
        if let toastView = APPLICATION.appDelegate.window?.viewWithTag(2532515){
            toastView.removeFromSuperview()
        }
    }
}
