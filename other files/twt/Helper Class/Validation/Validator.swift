//
//  Validator.swift
//  BVEcommerceMobileApp
//
//  Created by Avinash on 25/01/18.
//  Copyright © 2018 Brainvire. All rights reserved.
//

import UIKit

class Validator: NSObject {

    class func isValidEmail(_ testStr:String) -> Bool {
        debugPrint("validate string: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) as NSPredicate? {
            return emailTest.evaluate(with: testStr)
        }
        return false
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate.trimmingCharacters(in: .whitespaces))
    }
    
    //For Quantity Check
    class func isValidQty(_ testStr:String) -> Bool {
        debugPrint("validate string: \(testStr)")
        let qtyRegEx = "^[1-9][0-9]*$"
        
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", qtyRegEx) as NSPredicate? {
            return emailTest.evaluate(with: testStr)
        }
        return false
    }
    
    //MARK: Checking empty string
    class  func isEmptyString (_ strValue : String) -> Bool{
        let str = strValue as NSString
        var isEmpty : Bool
        if str .isEqual(to: "")
        {
            isEmpty = true
        }else{
            isEmpty = false
        }
        return isEmpty
    }
    
    /*Check for extra space*/
    class func checkSpacesBeforeString(string: String) -> Bool {
        let trimmed = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmed == "" {
            return true
        }
        return false
    }
    
    /*For Password Validation*/
    class func isvalidPassword(_ value : String) -> Bool
    {
        debugPrint("validate string: \(value)")
        let passwordRegEx = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!?@#$%^&+=.])(?=\\S+$).{8,}"
//                            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
//                            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}"
//                            "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=.])(?=\\S+$).{8,}" (Android)
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx) as NSPredicate?
        let isValid: Bool = passwordTest!.evaluate(with: value) as Bool
        if isValid{
            return false
        }else{
            return true
        }
        
        
//        if value.count >= 5 && value.count < 16
//        {
//            return true
//        }
//        return false
    }
    
    /*For Password and confirm Password*/
    class func isPasswordMatch(_ password1: String, _ password2: String) -> Bool {
        if password1.isEqual(password2) {
            return true
        }
        return false
    }

    
    /*For ImageView Validation*/
    class func isProfileImage(_ imageView : UIImageView) -> Bool
    {
        if imageView.image != nil
        {
            return true
        }
        return false
    }
    
}
