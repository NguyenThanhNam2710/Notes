//
//  UICollectionViewAvoidKeyboard.swift
//  ScrollViewAvoidKeyboard
//
//  Created by Tuan Hoang Anh on 14/06/2021.
//

import Foundation
import UIKit

// MARK: - CollectionView
public class UICollectionViewAvoidKeyboard: UICollectionView {
    
    public override var contentSize: CGSize {
        willSet(newValue) {
            if newValue.equalTo(contentSize) {
                return
            }
            super.contentSize = newValue
            updateContentInset()
        }
    }
    
    
    public override var frame: CGRect{
        willSet(newValue) {
            if newValue.equalTo(self.frame) {
                return
            }
            super.frame = frame
            updateContentInset()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerObserver()
        
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        registerObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            cancelPerform()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyBoard()
        super.touchesEnded(touches, with: event)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        callPerform()
    }
}

extension UICollectionViewAvoidKeyboard: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !focusNextTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UICollectionViewAvoidKeyboard: UITextViewDelegate {
    
}

extension UICollectionViewAvoidKeyboard {
    
    public func cancelPerform() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(assignTextDelegateForViewsBeneathView(_:)), object: self)
    }
    
    public func callPerform() {
        cancelPerform()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
    
    public func hideKeyBoard() {
        findFirstResponderBeneathView(self)?.resignFirstResponder()
    }
    
    public func focusNextTextField() -> Bool {
        return keyboard_focusNextTextField()
    }
    
    public func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
    }
}
