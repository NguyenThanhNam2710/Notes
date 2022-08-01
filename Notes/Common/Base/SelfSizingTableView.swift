//
//  File.swift
//  MagicApp
//
//  Created by Tuan IT. Hoang Anh on 16/06/2022.
//

import Foundation
import UIKit

class SelfSizingTableView: UITableView {
    var maxHeight: CGFloat = .infinity
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(maxHeight, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}
