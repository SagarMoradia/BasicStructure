//
//  UserDefault.swift
//  Capchur
//
//  Created by Hitesh Surani on 19/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DefaultValue: NSObject {
    static let shared:DefaultValue = DefaultValue()
    
    func removeAllValueFromUserDefault(){
        
        let deviceToken = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.DEVICE_TOKEN)
        let isFirstLogin = DefaultValue.shared.getBoolValue(key:KEYS_USERDEFAULTS.ISFIRSTLOGIN)
        let isRemberMe = DefaultValue.shared.getBoolValue(key:KEYS_USERDEFAULTS.IS_REMEMBER_ME)
        let email = getUserDefault(KEYS_USERDEFAULTS.USER_EMAIL) as? String ?? ""
        let password = getUserDefault(KEYS_USERDEFAULTS.USER_PASSWORD) as? String ?? ""
        let age_Verified = DefaultValue.shared.getBoolValue(key:KEYS_USERDEFAULTS.IS_AGE_VERIFIED)
        let lic_Verified = DefaultValue.shared.getBoolValue(key:KEYS_USERDEFAULTS.IS_LICENCE_VERIFIED)

        
        //Remove All User default value
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
            
        //Set Required Value Again to user default
        DefaultValue.shared.setBoolValue(value:age_Verified, key:KEYS_USERDEFAULTS.IS_AGE_VERIFIED)
        DefaultValue.shared.setBoolValue(value:lic_Verified, key:KEYS_USERDEFAULTS.IS_LICENCE_VERIFIED)
        DefaultValue.shared.setStringValue(value: email, key: KEYS_USERDEFAULTS.USER_EMAIL)
        DefaultValue.shared.setStringValue(value: password, key: KEYS_USERDEFAULTS.USER_PASSWORD)
        DefaultValue.shared.setBoolValue(value:isRemberMe, key:KEYS_USERDEFAULTS.IS_REMEMBER_ME)
        DefaultValue.shared.setStringValue(value: deviceToken, key: KEYS_USERDEFAULTS.DEVICE_TOKEN)
        DefaultValue.shared.setBoolValue(value:isFirstLogin, key:KEYS_USERDEFAULTS.ISFIRSTLOGIN)
    }
    
    
    
    
    func setArrayToUserDefault(value:[String],key:String){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func getArrayFromUserDefault(key:String) -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? [String]()
    }
    
    
    
    
    
    
    func setUserDefault(value:AnyObject,key:String){
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func getUserDefault(key:String) -> AnyObject {
        return UserDefaults.standard.object(forKey: key) as AnyObject
    }
    
    func setStringValue(value:String,key:String){
        UserDefaults.standard.set(value, forKey:key)
    }
    
    func getStringValue(key:String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    func setIntValue(value:Int,key:String){
        UserDefaults.standard.set(value, forKey:key)
    }
    
    func getIntValue(key:String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    
    func setBoolValue(value:Bool,key:String){
        UserDefaults.standard.set(value, forKey:key)
    }
    
    func getBoolValue(key:String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setLocation(location:CLLocation,key:String){
        let archived = NSKeyedArchiver.archivedData(withRootObject: location)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getLocation(key:String)->AnyObject?{
        
        guard let archived = UserDefaults.standard.object(forKey: key) as? Data,
            let location = NSKeyedUnarchiver.unarchiveObject(with: archived) as? CLLocation else {
                return nil
        }
        return location

    }
    
    
    func setUserInfo(user:userData){
        
        do {
            try UserDefaults.standard.set(object: user, forKey: KEYS_USERDEFAULTS.user_data)
            
        } catch let error {
            print(error)
        }
        
        
        UserDefaults.standard.synchronize()
        
    }
    
    func getUserInfo()->AnyObject?{
        
        
        do {
            let userInfo = try UserDefaults.standard.get(objectType:userData.self, forKey: KEYS_USERDEFAULTS.user_data) as AnyObject
            
            return userInfo
        } catch let error {
            print(error)
            return nil
        }
        
    }
 
    
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = UserDefaults.standard.data(forKey: key) {
//        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        UserDefaults.standard.set(imageData, forKey: key)
        //set(imageData, forKey: key)
    }
    
}

public extension UserDefaults {
    
    
    public func set<T: Codable>(object: T, forKey: String) throws {
        
        let jsonData = try JSONEncoder().encode(object)
        
        set(jsonData, forKey: forKey)
    }
    
    
    public func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        
        return try JSONDecoder().decode(objectType, from: result)
    }
}



