//
//  BaseCustomView.swift
//  MagicApp
//
//  Created by Tuan IT. Hoang Anh on 14/06/2022.
//

import Foundation
import UIKit

@IBDesignable
open class BaseCustomView: UIView {

    // MARK: - NibView
    fileprivate var backgroundView: UIView!

    // MARK: - Inits
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
        setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
        setupUI()
    }

     func loadFromNib() {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))

        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = nil
        
        self.backgroundView = view
        self.addSubview(view)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
}

@objc extension BaseCustomView {
    open func setupUI() {
        self.backgroundColor = UIColor.clear
    }
}
