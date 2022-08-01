//
//  Bundle+Extension.swift
//  ShowWeb
//
//  Created by Nam Nguyễn Thành on 20/07/2022.
//

import Foundation
import UIKit

extension Bundle {
    
    func loadView<T: UIView>(with className: T.Type) -> T {
        return self.loadNibNamed(String(describing: className), owner: nil, options: nil)?.first as! T
    }
    
    var version: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildNumber: String? {
        return self.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}
