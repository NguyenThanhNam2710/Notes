//
//  UITableViewAvoidKeyboard.swift
//  ScrollViewAvoidKeyboard
//
//  Created by Tuan Hoang Anh on 14/06/2021.
//

import Foundation
import UIKit


// MARK: - TableView
public class UITableViewAvoidKeyboard: UITableView {
    
    public override var frame: CGRect {
        willSet(newValue) {
            if newValue.equalTo(frame) {
                return
            }
            super.frame = frame
        }
        didSet {
            if hasAutomaticKeyboardAvoidingBehaviour() {return}
            updateContentInset()
        }
    }
    
    public override var contentSize: CGSize {
        willSet(newValue) {
            if newValue.equalTo(contentSize) {
                return
            }
            if hasAutomaticKeyboardAvoidingBehaviour() {
                super.contentSize = newValue
                return
            }
            super.contentSize = newValue
        }
        didSet {
            updateContentInset()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerObserver()
    }
    
    public override func awakeFromNib() {
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

extension UITableViewAvoidKeyboard: UITextFieldDelegate {
    
    public func cancelPerform() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(assignTextDelegateForViewsBeneathView(_:)), object: self)
    }
    
    public func callPerform() {
        cancelPerform()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !focusNextTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UITableViewAvoidKeyboard: UITextViewDelegate {
    
}

extension UITableViewAvoidKeyboard {
    
    public func hideKeyBoard() {
        findFirstResponderBeneathView(self)?.resignFirstResponder()
    }
    
    public func hasAutomaticKeyboardAvoidingBehaviour()->Bool {
        if #available(iOS 8.3, *) {
            if self.delegate is UITableViewController {
                return true
            }
        }
        return false
    }
    
    public func focusNextTextField()->Bool {
        return keyboard_focusNextTextField()
    }
    
    public func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func registerObserver() {
        if hasAutomaticKeyboardAvoidingBehaviour() { return }
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
