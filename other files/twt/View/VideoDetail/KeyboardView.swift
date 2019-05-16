//
//  KeyboardView.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 13/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

typealias CompletionHandlerKeyboard = (( _ index:Int, _ strTitle:String)->())?

enum KeyboardEvent : Int{
    case AddComment = 101
    case EditComment
    case AddReply
    case EditReply
}

class KeyboardView: UIView,UITextFieldDelegate{
    
    //MARK: - Outlets Methods
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewKeyboard: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var cntrlSend: UIControl!
    @IBOutlet weak var txtReply: UITextField!
    @IBOutlet weak var ConstrainBottomSpace: NSLayoutConstraint!
    
    //MARK: - Properties Methods
    //Callback
    var handler: CompletionHandlerKeyboard!
    var keyboardEventVal = KeyboardEvent.AddComment
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func awakeFromNib() {
        makeBorder(yourView: imgViewProfile, cornerRadius: imgViewProfile.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
        self.addShadowToView(view: viewKeyboard)
    }
    
    override func layoutSubviews() {
        self.checkProfilePic()
    }
    
    //MARK: - Setup Methods
    func setKeyboard()  {
        registerKeyboardObserver()
    }
    
    func removeKeyboard()  {
        removeKeyboardObserver()
    }
    
    func addShadowToView(view:UIView) {
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowRadius = 1
        view.layer.shadowColor = UIColor.textColor_black_unselected.cgColor
        view.layer.masksToBounds = false
    }
    
    fileprivate func checkProfilePic() {
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            imgViewProfile.frame = CGRect(x: 12.0, y:12, width: 24.0, height: 24.0)
            imgViewProfile.image = UIImage(named: Cons_Profile_Image_Name)
            imgViewProfile.contentMode = .scaleAspectFit
            imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height / 2
            imgViewProfile.clipsToBounds = true
        }else{
            let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String
            if self.verifyUrl(urlString: profileURL){
                imgViewProfile.frame = CGRect(x: 3.5, y:3.5, width: 36.0, height: 36.0)
                loadImageWith(imgView: imgViewProfile, url: profileURL)
                imgViewProfile.contentMode = .scaleAspectFill
                imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height / 2
                imgViewProfile.clipsToBounds = true
            }else{
                imgViewProfile.frame = CGRect(x: 12.0, y:12, width: 24.0, height: 24.0)
                imgViewProfile.image = UIImage(named: Cons_Profile_Image_Name)
                imgViewProfile.contentMode = .scaleAspectFit
                imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height / 2
                imgViewProfile.clipsToBounds = true
            }
        }
    }
    
    
    //MARK: - Button Event Methods
    @IBAction func actionSend(_ sender:UIControl){
        //Send button
        txtReply.text = txtReply.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        DispatchQueue.main.async {
            self.removeKeyboard()
            //Hide with animation
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect.init(x: 0, y: 2000, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (result : Bool) in
                self.removeFromSuperview()
                self.handler!(self.keyboardEventVal.rawValue,self.txtReply.text!)
            }
        }
        
    }
    
    @IBAction func actionHide(_ sender:UIControl){
        //Send button
        txtReply.text = txtReply.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        DispatchQueue.main.async {
            self.removeKeyboard()
            //Hide with animation
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect.init(x: 0, y: 2000, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (result : Bool) in
                self.removeFromSuperview()
                self.handler!(sender.tag,self.txtReply.text!)
            }
        }
        
    }

    
    //MARK: - Keyboard Handling Methods
    @objc func keyboardWillShowComment(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight: CGFloat
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        //UIView.animate(withDuration: 0.3) {
            self.ConstrainBottomSpace.constant = keyboardHeight
            self.viewKeyboard.alpha = 1.0
            self.layoutIfNeeded()
       // }
    }
    
    @objc func keyboardWillHideComment(notification: Notification) {
       // UIView.animate(withDuration: 0.1) {
            self.ConstrainBottomSpace.constant = 0.0
            self.viewKeyboard.alpha = 0.0
            self.layoutIfNeeded()
        //}
    }
    
    
    func registerKeyboardObserver(){
        
        txtReply.becomeFirstResponder()
        
        //IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowComment), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideComment), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func removeKeyboardObserver(){
        
        txtReply.resignFirstResponder()
        
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    
    //MARK:- Textfield delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        print(newString)
        var charCount = textField.text?.count
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92){
            charCount = charCount! - 1
            if charCount! == 0{
                cntrlSend.isHidden = true
            }else{
                cntrlSend.isHidden = false
            }
        }else{
            if charCount! >= 0 {
                cntrlSend.isHidden = false
            }
        }
        
        if textField == txtReply{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            return numberOfChars < 1001
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
