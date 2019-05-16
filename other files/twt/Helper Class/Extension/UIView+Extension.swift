//
//  UIView+Extension.swift
//  Created by bviadmin on 27/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit


extension UIView {
    
    func presentSubviewWithAnimationFromBottom(){
        
        let rootVC = APPLICATION().topVCForPresent
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        self.alpha = 0
        vc.view.addSubview(self)
        //vc.providesPresentationContextTransitionStyle = true
        //vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext
        rootVC?.present(vc, animated: true, completion: {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        })
    }
    
    func dismissFromSuperviewWithAnimationFromBottom(completion:@escaping ()-> Void){
        let rootVC = APPLICATION().topVCForPresent
        self.alpha = 0
        rootVC?.dismiss(animated: true, completion: {
        })
    }
    
    func addSubviewWithAnimationBottom(animation:@escaping ()-> Void, completion:@escaping ()-> Void){
        
        //SMP:Change
        UIApplication.shared.keyWindow?.addSubview(self)
        self.backgroundColor = .clear
            
        self.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            animation()
        }) { (true) in
            self.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
            completion()            
        }
    }
    
    func removeFromSuperviewWithAnimationBottom(animation:@escaping ()-> Void, completion:@escaping ()-> Void){
        
        //SMP:Change
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.6, animations: {
            self.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            animation()
        }) { (result : Bool) in
            completion()
            self.removeFromSuperview()
        }
    }
    
    func addSubviewWithAnimationCenter(animation:@escaping ()-> Void, completion:@escaping ()-> Void){
        
        self.backgroundColor = .clear
        self.transform = self.transform.scaledBy(x: 0.01, y: 0.01)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
            animation()
            
        }) { (result : Bool) in
            self.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
            completion()
        }
    }
    
    func removeFromSuperviewWithAnimationCenter(animation:@escaping ()-> Void, completion:@escaping ()-> Void){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.alpha = 0
            self.transform = self.transform.scaledBy(x: 0.01, y: 0.01)
            animation()
        }, completion: { (_) in
            self.removeFromSuperview()
            completion()
            self.transform = CGAffineTransform.identity
            self.backgroundColor = .clear
        })
    }
    
    func makeBorder(yourView:UIView,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor,borderColorAlpha:CGFloat) {
        yourView.layer.cornerRadius = cornerRadius
        yourView.layer.borderWidth = borderWidth
        yourView.layer.borderColor = borderColor.withAlphaComponent(borderColorAlpha).cgColor
        yourView.clipsToBounds = true
    }
    
    func g_addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
    }
    
    func g_addRoundBorder() {
        layer.borderWidth = 1
        layer.borderColor = Config.Grid.FrameView.borderColor.cgColor
        layer.cornerRadius = 3
        clipsToBounds = true
    }
    
    func g_quickFade(visible: Bool = true) {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = visible ? 1 : 0
        })
    }
    
    func g_fade(visible: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = visible ? 1 : 0
        })
    }
    
    struct Static {
        static var key = "key"
    }
    var viewIdentifier: String? {
        get {
            return objc_getAssociatedObject( self, &Static.key ) as? String
        }
        set {
            objc_setAssociatedObject(self, &Static.key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func allSubViewsOf() -> [UIView]{
        var all = [UIView]()
        
        func getSubview(view: UIView) {
            all.append(view)
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        
        getSubview(view: self)
        return all
    }
}


extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func defaultMontserratFont(style: String, size: CGFloat) -> UIFont {
        return customFont(name: "Montserrat-\(style)", size: size)
    }
}

//MARK:- UITapGestureRecognizer
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
    
    
}
