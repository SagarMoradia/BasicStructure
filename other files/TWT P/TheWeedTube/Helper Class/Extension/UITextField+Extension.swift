//
//  UITextField+Extension.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 SM. All rights reserved.
//

import UIKit

private var kAssociationKeyMaxLength: Int = 0
private var kAssociationKeyMaxLengthTextView: Int = 0

//MARK:- Textfield class for disable Copy Paste
var key: Void?

class UITextFieldAdditions: NSObject {
    var readonly: Bool = false
}

extension UITextField {
    var readonly: Bool {
        get {
            return self.getAdditions().readonly
        } set {
            self.getAdditions().readonly = newValue
        }
    }
    
    private func getAdditions() -> UITextFieldAdditions {
        var additions = objc_getAssociatedObject(self, &key) as? UITextFieldAdditions
        if additions == nil {
            additions = UITextFieldAdditions()
            objc_setAssociatedObject(self, &key, additions!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return additions!
    }
    
    open override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if ((action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || (action == #selector(UIResponderStandardEditActions.cut(_:)))) && self.readonly) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

extension UITextView:UITextViewDelegate {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLengthTextView) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            
            if(self.delegate == nil){
                self.delegate = self
            }
            objc_setAssociatedObject(self, &kAssociationKeyMaxLengthTextView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView: self)
    }
    @objc func checkMaxLength(textView: UITextView) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}
