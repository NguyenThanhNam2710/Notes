//
//  UITableView+Extension.swift
//  Foxpay
//
//  Created by Nam Nguyễn Thành on 20/07/2022.
//

import Foundation
import UIKit

protocol CellDataProtocol {
    func setData(_ data: Any?)
}

typealias TableItem = (cellType: UITableViewCell.Type, data: Any?)
typealias TableItems = [TableItem]
typealias TableSection = (header: UIView?, headerHeight: CGFloat, items: TableItems)
typealias TableSections = [TableSection]

typealias CollectionItem = (cellType: UICollectionViewCell.Type, data: Any?)
typealias CollectionItems = [CollectionItem]

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(with classType: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: classType)) as! T
    }
    
    func registerNib<T: UITableViewCell>(with classType: T.Type, in bundle: Bundle? = nil) {
        self.register(UINib(nibName: String(describing: classType), bundle: bundle) , forCellReuseIdentifier: String(describing: classType))
    }
    
    
    func beginEdit() {
        for i in 0..<self.numberOfSections {
            for j in 0..<self.numberOfRows(inSection: i) {
                if let cell = self.cellForRow(at: IndexPath(row: j, section: i)) {
                    if let textField = cell.textField() {
                        textField.becomeFirstResponder()
                        return
                    } else if let textView = cell.textView() {
                        textView.becomeFirstResponder()
                        return
                    }
                }
            }
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0) {
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
    
}
