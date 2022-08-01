//
//  UITableViewAvoidKeyboard.swift
//  ScrollViewAvoidKeyboard
//
//  Created by Tuan Hoang Anh on 14/06/2021.
//

import Foundation
import UIKit

// MARK: - ScrollView
public class UIScrollViewAvoidKeyboard: UIScrollView {
    
    // MARK: - Property
    public override var contentSize: CGSize {
        willSet(newValue) {
            if newValue.equalTo(contentSize) {
                return
            }
            super.contentSize = newValue
            updateFromContentSizeChange()
        }
    }
    
    public override var frame: CGRect {
        willSet(newValue) {
            if newValue.equalTo(frame) {
                return
            }
            super.frame = newValue
            updateContentInset()
        }
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerObserver()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        registerObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    // MARK: - Override
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

// MARK: - Extension
extension UIScrollViewAvoidKeyboard: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !focusNextTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UIScrollViewAvoidKeyboard: UITextViewDelegate {
    // TO DO
}

extension UIScrollViewAvoidKeyboard {
    
    public func cancelPerform() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(assignTextDelegateForViewsBeneathView(_:)), object: self)
    }
    
    /// register Delegate
    public func callPerform() { /// when call -> cancel
        cancelPerform()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
    
    public func hideKeyBoard() {
        findFirstResponderBeneathView(self)?.resignFirstResponder()
    }
    
    public func contentSizeToFit() {
        contentSize = calculatedContentSizeFromSubviewFrames()
    }
    
    public func focusNextTextField() -> Bool {
        return keyboard_focusNextTextField()
    }
    
    public func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func registerObserver() {
        /// UIKeyboardWillChangeFrame
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        /// UIKeyboardWillHide
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        /// UITextViewTextDidBeginEditing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: nil)
        /// UITextFieldTextDidBeginEditing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
    }
}

// MARK: - Process Event
let kCalculatedContentPadding: CGFloat = 10
let kMinimumScrollOffsetPadding: CGFloat = 20

extension UIScrollView {
    private struct Space {
        static var spaceBetweenKeyboardAndInputView: CGFloat = 0
    }
    
    public func setSpaceBetweenKeyboardAndInputView(_ space: CGFloat) {
        UIScrollView.Space.spaceBetweenKeyboardAndInputView = space
    }
    
    @objc public func keyboardWillShow(_ notification:Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let rectNotification = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRect = convert(rectNotification.cgRectValue , from: nil)
        if keyboardRect.isEmpty {
            return
        }
        
        let state = keyboardState()
        guard let firstResponder = findFirstResponderBeneathView(self) else { return}
        state.keyboardRect = keyboardRect
        if !state.keyboardVisible {
            state.priorInset = contentInset
            state.priorScrollIndicatorInsets = scrollIndicatorInsets
            state.priorPagingEnabled = isPagingEnabled
        }
        
        state.keyboardVisible = true
        isPagingEnabled = false
        if self is UIScrollViewAvoidKeyboard {
            state.priorContentSize = contentSize
            if contentSize.equalTo(CGSize.zero) {
                contentSize = calculatedContentSizeFromSubviewFrames()
            }
        }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self]() -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentInset = strongSelf.contentInsetForKeyboard()
            let viewableHeight = strongSelf.bounds.size.height - (strongSelf.contentInset.top + strongSelf.contentInset.bottom)
            let point = CGPoint(x: strongSelf.contentOffset.x, y: strongSelf.idealOffsetForView(firstResponder, viewAreaHeight: viewableHeight))
            strongSelf.setContentOffset(point, animated: false)
            strongSelf.scrollIndicatorInsets = strongSelf.contentInset
            strongSelf.layoutIfNeeded()
        }) { (finished) -> Void in
        }
    }
    
    @objc public func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let rectNotification = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRect = convert(rectNotification.cgRectValue , from: nil)
        if keyboardRect.isEmpty {
            return
        }
        let state = keyboardState()
        if !state.keyboardVisible {
            return
        }
        state.keyboardRect = CGRect.zero
        state.keyboardVisible = false
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self]() -> Void in
            guard let strongSelf = self else {
                return
            }
            if strongSelf is UIScrollViewAvoidKeyboard {
                strongSelf.contentSize = state.priorContentSize
                strongSelf.contentInset = state.priorInset
                strongSelf.scrollIndicatorInsets = state.priorScrollIndicatorInsets
                strongSelf.isPagingEnabled = state.priorPagingEnabled
                strongSelf.layoutIfNeeded()
            }
        }) { (finished) -> Void in
        }
    }
    
    public func updateFromContentSizeChange() {
        let state = keyboardState()
        if state.keyboardVisible {
            state.priorContentSize = contentSize
        }
    }
    
    public func keyboard_focusNextTextField() -> Bool {
        guard let firstResponder = findFirstResponderBeneathView(self) else { return false}
        guard let view = findNextInputViewAfterView(firstResponder, beneathView: self) else { return false}
        Timer.scheduledTimer(timeInterval: 0.1, target: view, selector: #selector(becomeFirstResponder), userInfo: nil, repeats: false)
        return true
    }
    
    @objc public func scrollToActiveTextField() {
        let state = keyboardState()
        if !state.keyboardVisible { return }
        let visibleSpace = bounds.size.height - (contentInset.top + contentInset.bottom)
        let y = idealOffsetForView(findFirstResponderBeneathView(self), viewAreaHeight: visibleSpace)
        let idealOffset = CGPoint(x: 0, y: y)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((Int64)(0 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {[weak self] () -> Void in
            self?.setContentOffset(idealOffset, animated: true)
        }
    }
    
    public func findFirstResponderBeneathView(_ view:UIView) -> UIView? {
        for childView in view.subviews {
            if childView.responds(to: #selector(getter: isFirstResponder)) && childView.isFirstResponder {
                return childView
            }
            let result = findFirstResponderBeneathView(childView)
            if result != nil {
                return result
            }
        }
        return nil
    }
    
    public func updateContentInset() {
        let state = keyboardState()
        if state.keyboardVisible {
            contentInset = contentInsetForKeyboard()
        }
    }
    
    public func calculatedContentSizeFromSubviewFrames() ->CGSize {
        let wasShowingVerticalScrollIndicator = showsVerticalScrollIndicator
        let wasShowingHorizontalScrollIndicator = showsHorizontalScrollIndicator
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        var rect = CGRect.zero
        for view in self.subviews{
            rect = rect.union(view.frame)
        }
        rect.size.height += kCalculatedContentPadding
        showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator
        showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator
        return rect.size
    }
    
    public func idealOffsetForView(_ view:UIView?,viewAreaHeight:CGFloat) -> CGFloat {
        let contentSize = self.contentSize
        var offset:CGFloat = 0.0
        let subviewRect =  view != nil ? view!.convert(view!.bounds, to: self) : CGRect.zero
        var padding = (viewAreaHeight - subviewRect.height)/2
        if padding < kMinimumScrollOffsetPadding {
            padding = kMinimumScrollOffsetPadding
        }
        
        offset = subviewRect.origin.y - padding - self.contentInset.top
        if offset > (contentSize.height - viewAreaHeight) {
            offset = contentSize.height - viewAreaHeight
        }
        if offset < -contentInset.top {
            offset = -contentInset.top
        }
        return offset
    }
    
    public func contentInsetForKeyboard() -> UIEdgeInsets {
        let state = keyboardState()
        var newInset = contentInset
        let keyboardRect = state.keyboardRect
        newInset.bottom = keyboardRect.size.height - max(keyboardRect.maxY - bounds.maxY, 0) + UIScrollView.Space.spaceBetweenKeyboardAndInputView
        return newInset
        
    }
    
    public func viewIsValidKeyViewCandidate(_ view: UIView)->Bool {
        if view.isHidden || !view.isUserInteractionEnabled {return false}
        if view is UITextField {
            if (view as! UITextField).isEnabled {return true}
        }
        
        if view is UITextView {
            if (view as! UITextView).isEditable {return true}
        }
        return false
    }
    
    public func findNextInputViewAfterView(_ priorView:UIView,beneathView view:UIView, candidateView bestCandidate: inout UIView?) {
        let priorFrame = convert(priorView.frame, to: priorView.superview)
        let candidateFrame = bestCandidate == nil ? CGRect.zero : convert(bestCandidate!.frame, to: bestCandidate!.superview)
        
        var bestCandidateHeuristic = -sqrt(candidateFrame.origin.x*candidateFrame.origin.x + candidateFrame.origin.y*candidateFrame.origin.y) + ( Float(abs(candidateFrame.minY - priorFrame.minY)) < .ulpOfOne ? 1e6 : 0)
        
        for childView in view.subviews {
            if viewIsValidKeyViewCandidate(childView) {
                let frame = convert(childView.frame, to: view)
                let heuristic = -sqrt(frame.origin.x*frame.origin.x + frame.origin.y*frame.origin.y)
                    + (Float(abs(frame.minY - priorFrame.minY)) < .ulpOfOne ? 1e6 : 0)
                
                if childView != priorView && (Float(abs(frame.minY - priorFrame.minY)) < .ulpOfOne
                    && frame.minX > priorFrame.minX
                    || frame.minY > priorFrame.minY)
                    && (bestCandidate == nil || heuristic > bestCandidateHeuristic) {
                    bestCandidate = childView
                    bestCandidateHeuristic = heuristic
                }
            } else {
                findNextInputViewAfterView(priorView, beneathView: view, candidateView: &bestCandidate)
            }
        }
    }
    
    public func findNextInputViewAfterView(_ priorView: UIView,beneathView view: UIView) ->UIView? {
        var candidate: UIView?
        findNextInputViewAfterView(priorView, beneathView: view, candidateView: &candidate)
        return candidate
    }
    
    @objc public func assignTextDelegateForViewsBeneathView(_ obj: AnyObject) {
        func processWithView(_ view: UIView) {
            for childView in view.subviews {
                if childView is UITextField || childView is UITextView {
                    initializeView(childView)
                } else {
                    assignTextDelegateForViewsBeneathView(childView)
                }
            }
        }
        
        if let timer = obj as? Timer, let view = timer.userInfo as? UIView {
            processWithView(view)
        } else if let view = obj as? UIView {
            processWithView(view)
        }
    }
    
    public func initializeView(_ view: UIView) {
        if let textField = view as? UITextField,
            let delegate = self as? UITextFieldDelegate, textField.returnKeyType == UIReturnKeyType.default &&
            textField.delegate !== delegate {
            textField.delegate = delegate
            let otherView = findNextInputViewAfterView(view, beneathView: self)
            textField.returnKeyType = otherView != nil ? .next : .done
        }
    }
    
    public func keyboardState() -> KeyboardState {
        if let state = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.key) as? KeyboardState {
            return state
        } else {
            let state = KeyboardState()
            self.state = state
            return state
        }
    }
}
public class KeyboardState {
    var priorInset = UIEdgeInsets.zero
    var priorScrollIndicatorInsets = UIEdgeInsets.zero
    var keyboardVisible = false
    var keyboardRect = CGRect.zero
    var priorContentSize = CGSize.zero
    var priorPagingEnabled = false
}

extension UIScrollView {
    public enum AssociatedKeysKeyboard {
        static var key = "KeyBoardSmart"
    }
    
    public var state: KeyboardState? {
        get { // get
            let optionalObject = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.key) as AnyObject?
            if let object = optionalObject {
                return object as? KeyboardState
            } else {
                return nil
            }
        }
        set { // set
            objc_setAssociatedObject(self, &AssociatedKeysKeyboard.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
