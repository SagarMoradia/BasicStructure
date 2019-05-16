//
//  Keyboard+Extension.swift
//  DELRentals
//
//  Created by Sweta Vani on 12/11/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation

import UIKit

private var xoAssociationKeyForBottomConstrainInVC: UInt8 = 0

extension UIViewController {
    
    var containerDependOnKeyboardBottomConstrain :NSLayoutConstraint! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKeyForBottomConstrainInVC) as? NSLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKeyForBottomConstrainInVC, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func watchForKeyboard () {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.containerDependOnKeyboardBottomConstrain.constant = -keyboardFrame.height
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.containerDependOnKeyboardBottomConstrain.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}

extension UIView {
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChange(_ notification: NSNotification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue



        let deltaY = endFrame.origin.y - beginningFrame.origin.y

        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
