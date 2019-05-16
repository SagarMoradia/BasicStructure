//
//  String+Extension.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit

extension String{
    
    //MARK:- String indicator if blank
    func stringAsIndicator(str:String) -> String {
        if(str.isEmpty){
            return "-"
        }
        return str
    }
    func stringAsNumber(str:String) -> String {
        if(str.isEmpty){
            return "0"
        }
        return str
    }
    
    var HSDecode: String {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            
            do{
                let decoded = try? NSAttributedString(data: Data(utf8), options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                    ], documentAttributes: nil).string
                
                return decoded ?? self
            }catch{
                return self
            }
        }else{
            return self
        }
    }
  
    func roundedWithAbbreviations(keyValue:String)->String
    {
        if self.count == 0{
           return keyValue
        }
        
        let number = Double(self) ?? 0.0
        let thousand = number / 1000
        let million = number / 1000000
        if number == 0.0{
            return keyValue
        }else if million >= 1.0 {
            return "  \(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "  \(round(thousand*10)/10)K"
        }
        else {
            return "  \(Int(number))"
        }
    }

    
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.characters.filter({ !characters.contains($0) }))
    }
    
    func removeWitespace() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func roundedWithAbbreviationsForSupporter()->String
    {
        if self.count == 0{
            return "0 Supporter"
        }
        
        let number = Double(self) ?? 0.0
        let thousand = number / 1000
        let million = number / 1000000
        if number == 0.0{
            return "0 Supporter"
        }else if million >= 1.0 {
            return "\(round(million*10)/10)M Supporters"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K Supporters"
        }
        else if number == 1.0 {
            return "1 Supporter"
        }
        else {
            return "\(Int(number)) Supporters"
        }
    }
    
    func roundedWithAbbreviationsForFollowers()->String
    {
        if self.count == 0{
            return "0 Subscriber"
        }
        
        let number = Double(self) ?? 0.0
        let thousand = number / 1000
        let million = number / 1000000
        if number == 0.0{
            return "0 Subscriber"
        }else if million >= 1.0 {
            return "\(round(million*10)/10)M Subscribers"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K Subscribers"
        }
        else if number == 1.0 {
            return "1 Subscriber"
        }
        else {
            return "\(Int(number)) Subscribers"
        }
    }
    
    //sam
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    // To get Localized string
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            // we set a default, just in case
            UserDefaults.standard.set("fr", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    //    //To Change the Language
    //    UserDefaults.standard.set("en", forKey: "i18n_language")
    //    UserDefaults.standard.synchronize()
    
    // Returns trim string
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // Returns length of string
    var length: Int{
        return self.count
    }
    
    // Returns length of string after trim it
    var trimmedLength: Int{
        return self.trimmed.length
    }
    
    //To check text field or String is blank or not
    var isStringBlank: Bool {
        get {
            let trimmed =
                self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber //validatePhone
    var isValidPhoneNumber: Bool {
        do {
            //^+(?:[0-9] ?){9,14}[0-9]$
            let regex = try NSRegularExpression(pattern: "^+(?:[0-9] ?){9,14}[0-9]$",  options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
            
        } catch {
            return false
        }
    }
    
    
    var isValidUserName : Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-z0-9_-]{3,}$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
            
        } catch {
            return false
        }
    }
    
    var isValidPassword : Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(?=.*\\d)[A-Za-z\\d]{4,}$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
            
        } catch {
            return false
        }
    }
    
//    func widthOfString(usingFont font: UIFont) -> CGFloat {
//        let fontAttributes = [NSAttributedString.Key.font: font]
//        let size = self.size(withAttributes: fontAttributes)
//        return size.width
//    }
    
    func getBlankValidationMessage() -> String {
        return String.init(format: "Please enter %@.", self)
    }
    
    func getInvalidFieldValidationMessage() -> String {
        return String.init(format: "Please enter valid %@.",self)
    }
    
    func getMinCharsValidationMessage(_ length : Int) -> String {
        return String.init(format: "Please enter minimum %ld characters in %@.",length,self)
    }
    
    func getInvalidFieldValidationMessageWithSuggestion(_ suggestionRequired : String) -> String {
        return String.init(format: "Please enter valid %@ %@.", self,suggestionRequired)
    }
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        
        return self.substring(from: range.upperBound)
    }
    
    func removingCharacters(inCharacterSet forbiddenCharacters:CharacterSet) -> String
    {
        var filteredString = self
        while true {
            if let forbiddenCharRange = filteredString.rangeOfCharacter(from: forbiddenCharacters)  {
                filteredString.removeSubrange(forbiddenCharRange)
            }
            else {
                break
            }
        }
        
        return filteredString
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
