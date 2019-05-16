//
//  Validator.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import Foundation
import UIKit

enum ValidationType:String{
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,150}"
    //case Password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$" //"^.{8,}$"
    case Password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,12}$"
    case ReTypePassword = ""
    case UserName = "[A-Za-z0-9_ ]{3,100}"
    case CompanyName = "^.{6,50}$"
    case MobileNumber = "^[0-9]{10,10}"
    case Url = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    case DecimalNumber = "^([0-9]+)?(\\.([0-9]+)?)?$"
    case DecimalNumberWithComma = "^([0-9, ]+)?(\\.([0-9, ]+)?)?$"
    case Pin = "[0-9]{4,4}"
    case ifsc = "^[A-Za-z]{4}[0-9]{6,7}$"
    case accountNumber = "[0-9]{9,18}"
    case pan = "[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}"
    case gstin = "[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9A-Za-z]{1}[Z]{1}[0-9a-zA-Z]{1}"
    case Blank
}

extension UIView {
    
    func ValidateAllTextField() -> Bool{

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        let aryAllTextField:[ACFloatingTextfield] = self.allSubViewsOf(type:ACFloatingTextfield.self)
        for txtField in aryAllTextField {
            if !txtField.isValidate(){
                return false
            }
        }
        return true
    }
    
    fileprivate func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}


extension ACFloatingTextfield{
    
    func setValidation(Type:ValidationType,fieldName:String){
        validation.append(Type)
        
        if Type == .Blank{
            validationErrorMessage.append("Please enter \(fieldName).")
        }
        else{
            validationErrorMessage.append("Please enter valid \(fieldName).")
        }
    }
    
    func setValidation(Type:ValidationType,message:String){
        validation.append(Type)
        validationErrorMessage.append(message)
    }
    
    func removeAllValidation(){
        validation.removeAll()
        validationErrorMessage.removeAll()
    }
    
    func removeValidationWithType(Type:ValidationType){
        
        for (index,validationType) in validation.enumerated(){
            if Type == validationType{
                validation.remove(at: index)
                validationErrorMessage.remove(at: index)
            }
        }

    }
    
    func removeAllValidationFromScreen(){
        let aryAllTextField:[ACFloatingTextfield] = self.allSubViewsOf(type:ACFloatingTextfield.self)
        for txtField in aryAllTextField {
            txtField.validation.removeAll()
            txtField.validationErrorMessage.removeAll()
        }
    }
    
    func setValidation(Type:ValidationType){
        validation.append(Type)
        
        if Type == .Blank{
            validationErrorMessage.append("Please enter \(self.placeholder?.lowercased() ?? "value")")
        }
        else{
            validationErrorMessage.append("Please enter valid \(self.placeholder?.lowercased() ?? "value")")
        }
    }
    
    func isValidate() -> Bool {
        
        var aryAllValidationStatus = [Bool]()
        
        var currentIndex = 0
            for type in validation{
                
                var isValid = false
                if type == .Blank{
                    isValid = isBlank()
                }
                else if type == .ReTypePassword{
                    isValid = isValidValue(regEX: ValidationType.Password.rawValue)
                }
                else{
                    isValid = isValidValue(regEX: type.rawValue)
                }
                
                if isValid {
                    aryAllValidationStatus.append(true)
                }else{
                    //SMP: Validation
                    //Alert.shared.showAlert(title:"Validation Failed", message:validationErrorMessage[currentIndex])
                    
                     self.showErrorWithText(errorText: "")
                    if type == .Password{ //For Strong Password suggestion...
                        self.showToastMessage(title: msg_Password)
                    }
                    else if type == .ReTypePassword{ //For Strong Password suggestion...
                        self.showToastMessage(title: msg_ReTypePassword)
                    }
                    else if type == .Pin{
                        self.showToastMessage(title: msg_Pin)
                    }
                    else if type == .MobileNumber{
                        self.showToastMessage(title: msg_MobileNo)
                    }
                    else if type == .UserName{
                        self.showToastMessage(title: msg_Username)
                    }
                    else{
                        //self.showErrorWithText(errorText: validationErrorMessage[currentIndex])
                        //sv changes
                        self.showToastMessage(title: validationErrorMessage[currentIndex])
                    }
                    
                 
                    self.shake()
                    
                    if let scrView = self.superview?.superview?.superview as? UIScrollView{
                        scrView.scrollRectToVisible(self.frame, animated: true)
                    }
                    else if let scrView = self.superview?.superview as? UIScrollView{
                        scrView.scrollRectToVisible(self.frame, animated: true)
                    }
                    else if let scrView = self.superview as? UIScrollView{
                        scrView.scrollRectToVisible(self.frame, animated: true)
                    }
                    
                    break
                }
                currentIndex = currentIndex + 1
            }
        
        if validation.count == aryAllValidationStatus.count {
            return true
        }else{
            return false
        }
    }
    
    func isValidValue(regEX:String)->Bool{
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regEX)
        return emailTest.evaluate(with: self.text)
    }
    

    func isBlank()->Bool{
        return !(self.text?.isEmpty)!
    }
}
