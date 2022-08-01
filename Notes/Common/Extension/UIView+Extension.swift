//
//  UIView+Extension.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var isCircle: Bool {
        set {
            objc_setAssociatedObject(self, "devIsCircle", NSNumber(booleanLiteral: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
            cornerRadius = CGFloat(cornerRadius)
        }
        get {
            guard let number = objc_getAssociatedObject(self, "devIsCircle") as? NSNumber else {
                return false
            }
            return number.boolValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(key) {
            layer.cornerRadius = isCircle ? min(bounds.height, bounds.width) / 2 : key
            layer.masksToBounds = true
        }
    }
}

extension UIView {
    
    func textField() -> UITextField? {
        if self is UITextField {
            return self as? UITextField
        }
        for subView in self.subviews {
            if let textField = subView.textField() {
                return textField
            }
        }
        return nil
    }
    
    func textView() -> UITextView? {
        if self is UITextView {
            return self as? UITextView
        }
        for subView in self.subviews {
            if let textField = subView.textView() {
                return textField
            }
        }
        return nil
    }
    
    func fadeIn(duration: TimeInterval = 1.0, completion: (()->Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
            completion?()
        })
    }
    
    func fadeOut(duration: TimeInterval = 1.0, completion: (()->Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
            completion?()
        })
    }
}
